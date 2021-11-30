class_name ChannelRESTAPI extends DiscordRESTAPI

func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

func get_channel(channel_id) -> Channel:
	var channel: Channel
	var request: RestRequest = rest_request(
		ENDPOINTS.CHANNEL.format({channel_id = channel_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var channel_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		channel = entity_manager.get_or_construct_channel(channel_data)
	return channel

func send_message(channel_id: int, params: Dictionary):
	var message: Message
	var request: RestRequest = rest_request(
		ENDPOINTS.CHANNEL_MESSAGES.format({channel_id = channel_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var message_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		message = entity_manager.get_or_construct_message(message_data)
	return message

func edit_message(channel_id: int, message_id: int, params: Dictionary):
	var message: Message
	var request: RestRequest = rest_request(
		ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var message_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		message = entity_manager.get_or_construct_message(message_data)
	return message
