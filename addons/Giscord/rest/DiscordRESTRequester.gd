class_name DiscordRESTRequester

func request_async(request: RestRequest) -> HTTPResponse:
	
	var response: HTTPResponse = yield(
	_request_async(
			request.url,
			request.headers,
			request.method,
			request.body
	), "completed")
	
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

func _request_async(url: String, headers: PoolStringArray = [], method: int = HTTPClient.METHOD_GET, data: PoolByteArray = []) -> HTTPResponse:
	return SimpleHTTPClient.new().request_async(url, headers, true, method, data)
