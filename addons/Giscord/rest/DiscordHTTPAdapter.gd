class_name DiscordHTTPAdapter extends Node

const AUTH_HEADER: String = "Authorization: Bot %s"
const USER_AGENT_HEADER: String = "User-Agent: %s (%s, %s)" % [Discord.LIBRARY, Discord.LIBRARY_URL, Discord.LIBRARY_VERSION]
const CONTENT_TYPE_HEADER: String = "Content-Type: application/json"

var _connection_state: ConnectionState

var http_client: HTTPClient

func _init(connection_state: ConnectionState) -> void:
	_connection_state = connection_state
	self.name = "HTTPAdapter"

func request_async(request: RestAction) -> Dictionary:
	var headers: PoolStringArray = []
	headers.append(AUTH_HEADER % _connection_state.token)
	headers.append(USER_AGENT_HEADER)
	headers.append(CONTENT_TYPE_HEADER)
	headers.append_array(request.get_headers())
	
	var response: Array = (
	yield(_request_async(
		request.get_url(),
		headers,
		request.get_method(),
		request.get_data()
	), "completed"))
	
	var result: Dictionary = {"error": OK}
	
	if response.size() == 1:
		result["error"] = response[0]
		return result
	
	result["data"] = request.callv("handle_response", response)
	
	return result

func _request_async(url: String, headers: PoolStringArray = [], method: int = HTTPClient.METHOD_GET, data: Dictionary = {}) -> Array:
	var http_request: HTTPRequest = HTTPRequest.new()
	add_child(http_request)
	var error: int = http_request.request(
		url,
		headers,
		true,
		method,
		to_json(data)
	)
	
	if error != OK:
		yield(get_tree(), "idle_frame")
		return [error]
	
	var response: Array = yield(http_request, "request_completed")
	
	http_request.queue_free()
	
	return response
