class_name RESTRateLimiter

const LIMIT_HEADER: String = "X-RateLimit-Limit"
const REMAINING_HEADER: String = "X-RateLimit-Remaining"
const RESET_HEADER: String = "X-RateLimit-Reset"
const RESET_AFTER_HEADER: String = "X-RateLimit-Reset-After"
const BUCKET_HEADER: String = "X-RateLimit-Bucket"
const GLOBAL_HEADER: String = "X-RateLimit-Global"
const RETRY_AFTER_HEADER: String = "Retry-After"

var route_regex: RegEx = RegEx.new()
var webhook_regex: RegEx = RegEx.new()
var reactions_regex: RegEx = RegEx.new()

var buckets: Dictionary # bucket_hash: String, bucket: RESTRateLimitBucket
var routes: Dictionary  # route: String, bucket_hash: String

var global: bool
var retry_after: int
var global_reset: int

var last_latency_ms: int

func _init() -> void:
	# (?!/channels|/guilds|/webhooks)
	
	# warning-ignore:return_value_discarded
	route_regex.compile("/(?<parameter>[a-z-]+)/\\d+")
	# warning-ignore:return_value_discarded
	webhook_regex.compile("/webhooks/[^/]+/[A-Za-z0-9-_]+")
	# warning-ignore:return_value_discarded
	reactions_regex.compile("/reactions/[^/]+/\\d+")
	
	var global_bucket := RESTRateLimitBucket.new("global", 50, 50, 1000)
	global_bucket.auto_reset = true
	add_bucket(global_bucket)

func add_bucket(bucket: RESTRateLimitBucket) -> void:
	buckets[bucket.key] = bucket

func parse_route(endpoint: String, method: int) -> String: 
	var route: String = endpoint
	
	route = route_regex.sub(route, "/$parameter/:id", true)
	route = webhook_regex.sub(route, "/webhooks/:id/:token")
	route = reactions_regex.sub(route, "/reactions/:id/:user_id")
	
	return _stringify_method(method) + route

func get_bucket(request: RestRequest) -> Array:
	var url: URL = URL.new(request.url)
	var parameters: PoolStringArray = url.path.split("/")
	parameters.remove(0) # /api
	parameters.remove(0) # /v{version_number}
	var route: String = parse_route("/" + parameters.join("/"), request.method)
	var bucket: RESTRateLimitBucket
	if routes.has(route):
		bucket = buckets.get(routes[route])
	if not bucket:
		bucket = RESTRateLimitBucket.new("", 1, 1)
	return [bucket, route]

func queue_request(request: RestRequest) -> HTTPResponse:
	var global_bucket: RESTRateLimitBucket = buckets["global"]
	var bucket_info: Array = get_bucket(request)
	var route_bucket: RESTRateLimitBucket = bucket_info[0]
	var route: String = bucket_info[1]
	
	route_bucket.add_to_queue(request)
	
	var state = route_bucket.wait_for_queue(request)
	if state is GDScriptFunctionState:
		yield(state, "completed")
	
	if global:
		yield(Awaiter.wait(global_reset - OS.get_ticks_msec()), "completed")
	
	var total_wait_time: int
	
	if not request.has_meta("skip-global-rate-limit"):
		if global_bucket.delay():
			total_wait_time += global_bucket.time_to_wait()
		global_bucket.use()
	
	if route_bucket.delay():
		total_wait_time += route_bucket.time_to_wait()
	
	yield(Awaiter.wait(total_wait_time), "completed")
	
	var response: HTTPResponse
	while true:
		var _start: int = OS.get_ticks_msec()
		response = yield(request.send_async(), "completed")
		last_latency_ms = OS.get_ticks_msec() - _start
		
		if response.code == HTTPClient.RESPONSE_TOO_MANY_REQUESTS:
			push_error("Discord REST: Rate Limited, url: %s" % request.url)
			
			var rate_limit_data: Dictionary = parse_json(response.body.get_string_from_utf8())
			var _retry_after = rate_limit_data.get(
				"retry_after",
				_get_header(response, RETRY_AFTER_HEADER).to_float()
			) * 1000
			global = bool(_get_header(response, GLOBAL_HEADER))
			if global:
				retry_after = _retry_after
				global_reset = _retry_after + OS.get_ticks_msec()
			yield(Awaiter.wait(_retry_after), "completed")
			global = false
			retry_after = 0
			global_reset = 0
			continue
		break
	
	var bucket_hash: String = _get_header(response, BUCKET_HEADER)
	if not bucket_hash.empty():
		routes[route] = bucket_hash
		if route_bucket.key.empty():
			route_bucket.key = bucket_hash
			add_bucket(route_bucket)
	
	route_bucket.limit = _get_header(response, LIMIT_HEADER).to_int()
	route_bucket.remaining = _get_header(response, REMAINING_HEADER).to_int()
	route_bucket.reset_after = int(_get_header(response, RESET_AFTER_HEADER).to_float() * 1000)
	
	route_bucket.remove_from_queue(request)
	
	return response

static func _stringify_method(http_method: int) -> String:
	var string: String
	match http_method:
		HTTPClient.METHOD_GET:
			string = "GET"
		HTTPClient.METHOD_POST:
			string = "POST"
		HTTPClient.METHOD_PUT:
			string = "PUT"
		HTTPClient.METHOD_DELETE:
			string = "DELETE"
		HTTPClient.METHOD_PATCH:
			string = "PATCH"
	return string

static func _get_header(response: HTTPResponse, name: String) -> String:
	var value: String = ""
	for header in response.headers:
		var entry: PoolStringArray = header.split(":", true, 1)
		if entry.size() == 2 and entry[0].strip_edges().to_lower() == name.to_lower():
			value = entry[1].strip_edges()
			break
	return value
