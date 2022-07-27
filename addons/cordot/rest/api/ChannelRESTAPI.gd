class_name ChannelRESTAPI extends DiscordRESTAPI

func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
) -> void:
	super(_token, _requester, _entity_manager)
	pass

func get_channel(channel_id: int) -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id})
	).method_get()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_channel_response(response)

func edit_channel(channel_id: int, params: Dictionary = {}) -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id})
	).json_body(params).method_patch()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_channel_response(response)

func delete_channel(channel_id: int) -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id})
	).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_channel_response(response)

func get_messages(channel_id: int, query: Dictionary = {limit = 50}) -> Array:
	var messages: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGES.format({channel_id = channel_id})
		+ (
			"?" + HTTPClient.new().query_string_from_dict(query)
			if not query.is_empty()
			else ""
		)
	).method_get()
	var response: HTTPResponse = await requester.request_async(request)
	if response.successful():
		var messages_data: Array = parse_json(response.body.get_string_from_utf8())
		for message_data in messages_data:
			messages.append(entity_manager.get_or_construct_message(message_data, true))
	return messages

func get_message(channel_id: int, message_id: int) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).method_get()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_message_response(response)

func create_message(channel_id: int, params: Dictionary):
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGES.format({channel_id = channel_id})
	).json_body(params).method_post()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_message_response(response)

func crosspost_message(channel_id: int, message_id: int) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CROSSPOST_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).empty_body().method_post()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_message_response(response)

func create_reaction(channel_id: int, message_id: int, emoji: Emoji) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_OWN_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).empty_body().method_put()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func delete_own_reaction(channel_id: int, message_id: int, emoji: Emoji) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_OWN_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func delete_user_reaction(channel_id: int, message_id: int, emoji: Emoji, user_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_USER_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded(),
			user_id = user_id
		})
	).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_reactions(channel_id: int, message_id: int, emoji: Emoji, after: int = 0, limit: int = 25) -> Array:
	var users: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
		+ "?limit=" + str(limit)
		+ ("&after=" + str(after)) if after > 0 else ""
	).method_get()
	var response: HTTPResponse = await requester.request_async(request)
	if response.successful():
		var users_data: Array = parse_json(response.body.get_string_from_utf8())
		for user_data in users_data:
			users.append(entity_manager.get_or_construct_user(user_data))
	return users

func delete_all_reactions(channel_id: int, message_id: int) -> void:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_REACTIONS.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).method_delete()
	await requester.request_async(request)

func delete_emoji_reactions(channel_id: int, message_id: int, emoji: Emoji) -> void:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).method_delete()
	await requester.request_async(request)


func edit_message(channel_id: int, message_id: int, params: Dictionary):
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = await requester.request_async(request)
	return _handle_message_response(response)

func delete_message(channel_id: int, message_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func bulk_delete_messages(channel_id: int, messages_ids: PackedStringArray) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_BULK_DELETE.format({channel_id = channel_id,})
	).json_body({messages = messages_ids}).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func edit_channel_permissions(channel_id: int, overwrite_id: int, params: Dictionary) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_PERMISSIONS.format({
			channel_id = channel_id,
			overwrite_id = overwrite_id
		})
	).json_body(params).method_put()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_channel_invites(channel_id: int) -> Array:
	var invites: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_INVITES.format({channel_id = channel_id})
	).method_get()
	var response: HTTPResponse = await requester.request_async(request)
	if response.successful():
		var invites_data: Array = parse_json(response.body.get_string_from_utf8())
		for invite_data in invites_data:
			invites.append(entity_manager.guild_manager.construct_invite(invite_data))
	return invites

func create_channel_invite(channel_id: int, params: Dictionary = {}) -> Guild.Invite:
	var invite: Guild.Invite = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_INVITES.format({channel_id = channel_id})
	).json_body(params).method_post()
	var response: HTTPResponse = await requester.request_async(request)
	if response.successful():
		var invite_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		invite = entity_manager.guild_manager.construct_invite(invite_data)
	return invite

func delete_channel_permission(channel_id: int, overwrite_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_PERMISSIONS.format({
			channel_id = channel_id,
			overwrite_id = overwrite_id
		})
	).method_delete()
	var response: HTTPResponse = await requester.request_async(request)
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func _handle_channel_response(response: HTTPResponse) -> Channel:
	var channel: Channel = null
	if response.successful():
		var channel_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		channel = entity_manager.get_or_construct_channel(channel_data)
	return channel

func _handle_message_response(response: HTTPResponse) -> Message:
	var message: Message = null
	if response.successful():
		var message_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		message = entity_manager.get_or_construct_message(message_data, true)
	return message
