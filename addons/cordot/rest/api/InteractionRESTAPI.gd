# Interaction REST API implementation.
class_name InteractionRESTAPI extends DiscordRESTAPI

# Constructs a new `InteractionRESTAPI` object.
func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

# Create a response to an interaction from the gateway.
# Returns `true` on success.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#create-interaction-response>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func create_response(interaction_id: int, interaction_token: String, params: Dictionary) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.INTERACTION_CALLBACK.format({
			interaction_id = interaction_id,
			token = interaction_token
		})
	).json_body(params).method_post()
	request.set_meta("skip-global-rate-limit", true)
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Returns the initial interaction response.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#get-original-interaction-response>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
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

# Edits the initial interaction response.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#edit-original-interaction-response> 
#
# doc-qualifiers:coroutine
# doc-override-return:Message
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

# Deletes the initial interaction response. Returns `true` on success.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#delete-original-interaction-response>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
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

# Creates a followup message for an interaction.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#create-followup-message>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
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

# Returns a followup message for an interaction.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#get-followup-message>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
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

# Edits a followup message for an Interaction.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#edit-followup-message>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
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

# Deletes a followup message for an Interaction.  
# <https://discord.com/developers/docs/interactions/receiving-and-responding#delete-followup-message>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
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
		message = entity_manager.get_or_construct_message(message_data, true)
	return message
