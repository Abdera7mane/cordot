class_name RestRequest

# warning-ignore-all:function_conflicts_variable
# warning-ignore-all:return_value_discarded

var url: String
var headers: Dictionary
var method: int
var body: PoolByteArray

func url(_url: String) -> RestRequest:
	url = _url
	return self

func headers(_headers: Dictionary) -> RestRequest:
	headers = _headers
	return self

func set_header(name: String, value: String) -> RestRequest:
	headers[name] = value
	return self

func method(_method: int) -> RestRequest:
	method = _method
	return self

func method_get() -> RestRequest:
	return method(HTTPClient.METHOD_GET)

func method_head() -> RestRequest:
	return method(HTTPClient.METHOD_HEAD)

func method_post() -> RestRequest:
	return method(HTTPClient.METHOD_POST)

func method_put() -> RestRequest:
	return method(HTTPClient.METHOD_PUT)

func method_delete() -> RestRequest:
	return method(HTTPClient.METHOD_DELETE)

func method_options() -> RestRequest:
	return method(HTTPClient.METHOD_OPTIONS)

func method_trace() -> RestRequest:
	return method(HTTPClient.METHOD_TRACE)

func method_connect() -> RestRequest:
	return method(HTTPClient.METHOD_CONNECT)

func method_patch() -> RestRequest:
	return method(HTTPClient.METHOD_PATCH)

func body(data: PoolByteArray) -> RestRequest:
	body = data
	return self

func json_body(data) -> RestRequest:
	if not has_header(HTTPHeaders.CONTENT_TYPE):
		set_header(HTTPHeaders.CONTENT_TYPE, "application/json")
	return body(to_json(data).to_utf8())

func empty_body() -> RestRequest:
	return body([]).set_header(HTTPHeaders.CONTENT_LENGTH, "0")

func get_header(name: String) -> String:
	var value: String
	for header in headers:
		var entry: PoolStringArray = header.split(":", true, 1)
		if entry.size() == 2 and entry[0].strip_edges() == name:
			value = entry[1].strip_edges()
			break
	return value

func has_header(name) -> bool:
	return headers.has(name)

func send_async() -> HTTPResponse:
	return SimpleHTTPClient.new().request_async(
		self.url,
		self.headers,
		true,
		self.method,
		self.body
	)
