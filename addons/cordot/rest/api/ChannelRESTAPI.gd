# Channel REST API implementation.
class_name ChannelRESTAPI extends DiscordRESTAPI

# Constructs a new `ChannelRESTAPI` object.
func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

# Gets the channel with the given `channel_id`.  
# <https://discord.com/developers/docs/resources/channel#get-channel>
#
# doc-qualifiers:coroutine
# doc-override-return:Channel
func get_channel(channel_id: int) -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_channel_response(response)

# Update a channel's settings.  
# <https://discord.com/developers/docs/resources/channel#modify-channel>
# 
# doc-qualifiers:coroutine
# doc-override-return:Channel
func edit_channel(channel_id: int, params: Dictionary = {}, reason: String = "") -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id}),
		reason
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_channel_response(response)

# Deletes a channel, or closes a private message.  
# <https://discord.com/developers/docs/resources/channel#get-channel>
#
# doc-qualifiers:coroutine
# doc-override-return:Channel
func delete_channel(channel_id: int, reason: String = "") -> Channel:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL.format({channel_id = channel_id}),
		reason
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_channel_response(response)

# Gets a list of messages in a channel.  
# <https://discord.com/developers/docs/resources/channel#get-channel-messages>
#
# doc-qualifiers:coroutine
# doc-override-return:Array
# doc-override-param-default:(1;{limit=50})
func get_messages(channel_id: int, query: Dictionary = {limit = 50}) -> Array:
	var messages: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGES.format({channel_id = channel_id})
		+ (
			"?" + HTTPClient.new().query_string_from_dict(query) 
			if not query.empty()
			else ""
		)
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var messages_data: Array = parse_json(response.body.get_string_from_utf8())
		for message_data in messages_data:
			messages.append(entity_manager.get_or_construct_message(message_data, true))
	return messages

# Gets a message in a channel.  
# <https://discord.com/developers/docs/resources/channel#get-channel-message>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func get_message(channel_id: int, message_id: int) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

# Creates a message in a channel.  
# <https://discord.com/developers/docs/resources/channel#create-message>
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func create_message(channel_id: int, params: Dictionary) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGES.format({channel_id = channel_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

# Cross-posts a message in a News Channel to following channels.  
# <https://discord.com/developers/docs/resources/channel#crosspost-message>
# 
# doc-qualifiers:coroutine
# doc-override-return:Message
func crosspost_message(channel_id: int, message_id: int) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CROSSPOST_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).empty_body().method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

# Creates a reaction for a message. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#create-reaction>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func create_reaction(channel_id: int, message_id: int, emoji: Emoji) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_OWN_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).empty_body().method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Deletes a reaction the current user has made for the message.  
# Returns `true` on success.
# <https://discord.com/developers/docs/resources/channel#delete-own-reaction>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_own_reaction(channel_id: int, message_id: int, emoji: Emoji) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_OWN_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Deletes another user's reaction. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#delete-user-reaction>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_user_reaction(channel_id: int, message_id: int, emoji: Emoji, user_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_USER_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded(),
			user_id = user_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Gets a list of users that reacted with the given `emoji`.  
# <https://discord.com/developers/docs/resources/channel#get-reactions>
#
# doc-qualifiers:coroutine
# doc-override-return:Array
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
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var users_data: Array = parse_json(response.body.get_string_from_utf8())
		for user_data in users_data:
			users.append(entity_manager.get_or_construct_user(user_data))
	return users

# Deletes all reactions on a message.  
# <https://discord.com/developers/docs/resources/channel#get-channel-message>
#
# doc-qualifiers:coroutine
# doc-override-return:void
func delete_all_reactions(channel_id: int, message_id: int) -> void:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_REACTIONS.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).method_delete()
	yield(requester.request_async(request), "completed")

# Deletes all the reactions for a given `emoji` on a message.  
# <https://discord.com/developers/docs/resources/channel#delete-all-reactions-for-emoji>
#
# doc-qualifiers:coroutine
# doc-override-return:void
func delete_emoji_reactions(channel_id: int, message_id: int, emoji: Emoji) -> void:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_REACTION.format({
			channel_id = channel_id,
			message_id = message_id,
			emoji = emoji.url_encoded()
		})
	).method_delete()
	yield(requester.request_async(request), "completed")

# Edits a previously sent message.  
# <https://discord.com/developers/docs/resources/channel#edit-message>
# 
# doc-qualifiers:coroutine
# doc-override-return:Message
func edit_message(channel_id: int, message_id: int, params: Dictionary) -> Message:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_message_response(response)

# Deletes a message. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#delete-message>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_message(channel_id: int, message_id: int, reason: String = "") -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_MESSAGE.format({
			channel_id = channel_id,
			message_id = message_id
		}),
		reason
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Delete multiple messages in a single request. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#bulk-delete-messages>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func bulk_delete_messages(channel_id: int, messages_ids: PoolStringArray, reason: String = "") -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.MESSAGE_BULK_DELETE.format({channel_id = channel_id,}),
		reason
	).json_body({messages = messages_ids}).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Edit the channel permission overwrites for a user or role in a channel.
# Only usable for guild channels. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#edit-channel-permissions>
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func edit_channel_permissions(channel_id: int, overwrite_id: int, params: Dictionary, reason: String) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_PERMISSIONS.format({
			channel_id = channel_id,
			overwrite_id = overwrite_id
		}),
		reason
	).json_body(params).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

# Returns a list of `Guild.Invite` objects for the channel.  
# <https://discord.com/developers/docs/resources/channel#get-channel-invites>
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func get_channel_invites(channel_id: int) -> Array:
	var invites: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_INVITES.format({channel_id = channel_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var invites_data: Array = parse_json(response.body.get_string_from_utf8())
		for invite_data in invites_data:
			invites.append(entity_manager.guild_manager.construct_invite(invite_data))
	return invites

# Create a new invite for the channel. Only usable for guild channels.  
# <https://discord.com/developers/docs/resources/channel#create-channel-invite>
#
# doc-qualifiers:coroutine
# doc-override-return:Invite
func create_channel_invite(channel_id: int, params: Dictionary = {}, reason: String = "") -> Guild.Invite:
	var invite: Guild.Invite = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_INVITES.format({channel_id = channel_id}),
		reason
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var invite_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		invite = entity_manager.guild_manager.construct_invite(invite_data)
	return invite

# Delete a channel permission overwrite for a user or role in a channel.
# Only usable for guild channels. Returns `true` on success.  
# <https://discord.com/developers/docs/resources/channel#delete-channel-permissions>
# 
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_channel_permission(channel_id: int, overwrite_id: int, reason: String) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CHANNEL_PERMISSIONS.format({
			channel_id = channel_id,
			overwrite_id = overwrite_id
		}),
		reason
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
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
