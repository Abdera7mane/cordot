class_name RestAction

func get_data() -> Dictionary:
	return {}

func get_headers() -> PoolStringArray:
	return PoolStringArray()

func get_method() -> int:
	return HTTPClient.METHOD_GET

func handle_response(_result: int, _response_code: int, _headers: PoolStringArray, _body: PoolByteArray):
	return null

func get_url() -> String:
	return ""
