# Discord REST API requester, uses a rate limiter to queue requests. 
class_name DiscordRESTRequester

# Rate limiter for this requester instance.
var limiter: RESTRateLimiter

# Constructs a new `DiscordRESTRequester`. `use_pool` specifies whether to use
# an HTTP connection pool (experimental unstable feature).
func _init(use_pool: bool = false) -> void:
	limiter = RESTRateLimiter.new(use_pool)

# Sends a request to the Discord REST API asynchronously and returns an
# `HTTPResponse` object.
# Prints a human-readable error message in case of failure.
#
# doc-qualifiers:coroutine
# doc-override-return:HTTPResponse
func request_async(request: RestRequest) -> HTTPResponse:
	var response: HTTPResponse = yield(limiter.queue_request(request), "completed")
	
	var failed: bool = false
	
	match response.code:
		HTTPClient.RESPONSE_BAD_REQUEST:
			failed = true
			print_error("The request was improperly formatted, or the server couldn't understand it", request)
		HTTPClient.RESPONSE_UNAUTHORIZED:
			failed = true
			print_error("The Authorization header is missing or invalid", request)
		HTTPClient.RESPONSE_FORBIDDEN:
			failed = true
			print_error("The Authorization token did not have permission to the resource", request)
		HTTPClient.RESPONSE_NOT_FOUND:
			failed = true
			print_error("The resource at the location specified doesn't exist", request)
		HTTPClient.RESPONSE_METHOD_NOT_ALLOWED:
			failed = true
			print_error("The HTTP method used is not valid for the location specified", request)
		HTTPClient.RESPONSE_BAD_GATEWAY: # GATEWAY UNAVAILABLE
			failed = true
			print_error("There was not a gateway available to process the request. Wait a bit and retry", request)
		var code:
			failed = code >= 500
			if failed:
				print_error("Server error when processing the request", request)
	if failed:
		var parse_result := JSON.parse(response.body.get_string_from_utf8().c_unescape())
		if parse_result.error == OK and parse_result.result is Dictionary:
			var error_object: Dictionary = parse_result.result
			if error_object.has("code"):
				printerr()
				print_error_object(error_object)
	
	return response

# Downloads a resource from the Discord REST API asynchronously.
#
# doc-qualifiers:coroutine
# doc-override-return:Resource
func cdn_download_async(_url: String) -> Resource:
	var url: Dictionary = URL.parse_url(_url)
	var path: String = url.path.split("?", true, 1)[0]
	path = path.split("#", true, 1)[0]
	var format: String = path.get_extension()
	
	var fail: bool = false
	if not format in DiscordREST.CDN_FILE_FORMATS:
		fail = true
		push_error("Discord CDN: %s is an invalid file format" % format)
#	if size < 16 or size > 4096 or not _power_of_2(size):
#		fail = true
#		push_error("Discord CDN: %d is an invalid size" % size)
	if fail:
		return yield(Awaiter.submit(), "completed")

	var response: HTTPResponse = yield(request_async(
		RestRequest.new().url(_url).method_get()
	), "completed")
	if not response.successful():
		return null
	var error: int = OK
	var image: Image = Image.new()
	match format:
		"jpg", "jpeg":
			error = image.load_jpg_from_buffer(response.body)
		"png":
			error = image.load_png_from_buffer(response.body)
		"webp":
			error = image.load_webp_from_buffer(response.body)
		_:
			return null
	if error != OK:
		printerr("Error when loading image from buffer: %d" % error)
	var texture: ImageTexture = ImageTexture.new()
	texture.create_from_image(image)
	return texture

# Gets the last request latency in milliseconds.
func get_last_latency_ms() -> int:
	return limiter.last_latency_ms

# doc-hide
func print_error(message: String, request: RestRequest) -> void:
	push_error("Discord REST: "+ message)
	printerr("Discord REST Error")
	printerr("message: ", message)
	printerr("URL: ", request.url)
	printerr("Method: ", limiter._stringify_method(request.method))
	printerr("Body length: ", request.body.size())

# doc-hide
func print_error_object(object: Dictionary) -> void:
	printerr("ERROR TRACE START")
	printerr()
	printerr("Error: %s (%s)" % [object["code"], object["message"]])
	
	if not object.has("errors"):
		printerr()
		printerr("ERROR TRACE END")
		return
	
	printerr("Errors:")
	
	var stack: Array = [object["errors"]]
	while stack:
		var dict: Dictionary = stack.pop_back()
		for key in  dict:
			var value = dict[key]
			if value is Dictionary:
				var path: String = dict.get("path", "")
				if key.is_valid_integer():
					path += "[%s]" % key
				else:
					path += "." + key
				value["path"] = path.lstrip(".")
				stack.append(value)
		if dict.has("_errors"):
			var path: String = dict.get("path", "")
			var tabbing: String
			if not path.empty():
				tabbing = "\t"
				printerr("\t%s:" % path)
			for error in dict["_errors"]:
				printerr(tabbing + "\t\u2022 %s: %s" % [error["code"], error["message"]])
	printerr()
	printerr("ERROR TRACE END")

static func _power_of_2(n: int) -> bool:
	return (n & (n - 1)) == 0 if n > 0 else false
