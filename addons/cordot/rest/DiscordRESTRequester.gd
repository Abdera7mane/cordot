class_name DiscordRESTRequester

var limiter: RESTRateLimiter

func _init() -> void:
	limiter = RESTRateLimiter.new()

func request_async(request: RestRequest) -> HTTPResponse:
	var response: HTTPResponse = yield(limiter.queue_request(request), "completed")
	
	match response.code:
		HTTPClient.RESPONSE_BAD_REQUEST:
			push_error("Discord REST: Bad Request, url: %s" % request.url)
		HTTPClient.RESPONSE_UNAUTHORIZED:
			push_error("Discord REST: Unauthorized, url: %s" % request.url)
		HTTPClient.RESPONSE_FORBIDDEN:
			push_error("Discord REST: Forbidden, url: %s" % request.url)
		HTTPClient.RESPONSE_NOT_FOUND:
			push_error("Discord REST: Not Found, url: %s" % request.url)
		HTTPClient.RESPONSE_METHOD_NOT_ALLOWED:
			push_error("Discord REST: Method Not Allowed, url: %s, method: %d" % [request.url, request.method])
		HTTPClient.RESPONSE_TOO_MANY_REQUESTS:
			push_error("Discord REST: Rate Limited, url: %s" % request.url)
	
	return response

func cdn_download_async(url: String) -> Resource:
	var _url: URL = URL.new(url)
	var format: String = _url.get_file_extension()
	
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
		RestRequest.new().url(url).method_get()
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

func get_last_latency_ms() -> int:
	return limiter.last_latency_ms

func _request_async(url: String, headers: PoolStringArray = [], method: int = HTTPClient.METHOD_GET, data: PoolByteArray = []) -> HTTPResponse:
	return SimpleHTTPClient.new().request_async(url, headers, true, method, data)

static func _power_of_2(n: int) -> bool:
	return (n & (n - 1)) == 0 if n > 0 else false
