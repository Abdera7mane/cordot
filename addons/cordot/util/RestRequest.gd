class_name RestRequest

# warning-ignore-all:function_conflicts_variable
# warning-ignore-all:return_value_discarded

var url: String
var headers: Dictionary
var method: int
var body: PackedByteArray

func set_url(_url: String) -> RestRequest:
	url = _url
	return self

func set_headers(_headers: Dictionary) -> RestRequest:
	headers = _headers
	return self

func set_header(name: String, value: String) -> RestRequest:
	headers[name] = value
	return self

func set_method(_method: int) -> RestRequest:
	method = _method
	return self

func method_get() -> RestRequest:
	return set_method(HTTPClient.METHOD_GET)

func method_head() -> RestRequest:
	return set_method(HTTPClient.METHOD_HEAD)

func method_post() -> RestRequest:
	return set_method(HTTPClient.METHOD_POST)

func method_put() -> RestRequest:
	return set_method(HTTPClient.METHOD_PUT)

func method_delete() -> RestRequest:
	return set_method(HTTPClient.METHOD_DELETE)

func method_options() -> RestRequest:
	return set_method(HTTPClient.METHOD_OPTIONS)

func method_trace() -> RestRequest:
	return set_method(HTTPClient.METHOD_TRACE)

func method_connect() -> RestRequest:
	return set_method(HTTPClient.METHOD_CONNECT)

func method_patch() -> RestRequest:
	return set_method(HTTPClient.METHOD_PATCH)

func set_body(data: PackedByteArray) -> RestRequest:
	body = data
	return self

func json_body(data) -> RestRequest:
	if not has_header(HTTPHeaders.CONTENT_TYPE):
		set_header(HTTPHeaders.CONTENT_TYPE, "application/json")
	return set_body(JSON.new().stringify(data).to_utf8_buffer())

func empty_body() -> RestRequest:
	return set_body([]).set_header(HTTPHeaders.CONTENT_LENGTH, "0")

func get_header(name: String) -> String:
	var value: String
	for header in headers:
		var entry: PackedStringArray = header.split(":", true, 1)
		if entry.size() == 2 and entry[0].strip_edges() == name:
			value = entry[1].strip_edges()
			break
	return value

func has_header(name) -> bool:
	return headers.has(name)

func send_async() -> HTTPResponse:
	return await SimpleHTTPClient.new().request_async(
		self.url,
		self.headers,
		true,
		self.method,
		self.body
	)
