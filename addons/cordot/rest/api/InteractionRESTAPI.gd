class_name InteractionRESTAPI extends DiscordRESTAPI

func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

func create_response(interaction_id: int, interaction_token: String, params: Dictionary) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_CALLBACK.format({
			interaction_id = interaction_id,
			token = interaction_token
		})
	).json_body(params).method_post()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.successful()

func get_original_response(application_id: int, interaction_token: String) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_ORIGINAL_RESPONSE.format({
			application_id = application_id,
			token = interaction_token
		})
	).method_get()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

func edit_original_response(application_id: int, interaction_token: String, params: Dictionary) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_ORIGINAL_RESPONSE.format({
			application_id = application_id,
			token = interaction_token
		})
	).json_body(params).method_patch()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

func delete_original_response(application_id: int, interaction_token: String) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_ORIGINAL_RESPONSE.format({
			application_id = application_id,
			token = interaction_token
		})
	).method_delete()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func create_followup_message(application_id: int, interaction_token: String, params: Dictionary) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CREATE_FOLLOWUP_MESSAGE.format({
			application_id = application_id,
			token = interaction_token
		})
	).json_body(params).method_post()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

func get_followup_message(application_id: int, interaction_token: String, message_id: int) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.FOLLOWUP_MESSAGE.format({
			application_id = application_id,
			token = interaction_token,
			message_id = message_id
		})
	).method_get()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

func edit_followup_message(application_id: int, interaction_token: String, message_id: int, params: Dictionary) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.FOLLOWUP_MESSAGE.format({
			application_id = application_id,
			token = interaction_token,
			message_id = message_id
		})
	).json_body(params).method_patch()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

func delete_followup_message(application_id: int, interaction_token: String, message_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_ORIGINAL_RESPONSE.format({
			application_id = application_id,
			token = interaction_token,
			message_id = message_id
		})
	).method_delete()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func _handle_message_response(response: HTTPResponse) -> Message:
	var message: Message = null
	if response.successful():
		var message_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		message = entity_manager.get_or_construct_message(message_data)
	return message
