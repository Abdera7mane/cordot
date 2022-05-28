class_name GuildRESTAPI extends DiscordRESTAPI

func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

func create_guild(guild_id: int, params: Dictionary) -> Guild:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILDS.format({guild_id = guild_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_response(response)

func get_guild(guild_id: int, with_counts: bool = false) -> Guild:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD.format({guild_id = guild_id})
		+ "?with_counts=" + str(with_counts)
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_response(response)

func get_guild_preview(guild_id: int) -> Object:
	return null

func edit_guild(guild_id: int, params: Dictionary = {}) -> Guild:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD.format({guild_id = guild_id})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_response(response)

func delete_guild(guild_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_guild_channels(guild_id: int) -> Array:
	var channels: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_CHANNELS.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var channels_data: Array = parse_json(response.body.get_string_from_utf8())
		for channel_data in channels_data:
			var channel: Channel = entity_manager.get_or_construct_channel(channel_data)
			channels.append(channel)
	return channels

func create_guild_channel(guild_id: int, params: Dictionary) -> Channel:
	var channel: Channel = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_CHANNELS.format({guild_id = guild_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var channel_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		channel = entity_manager.get_or_construct_channel(channel_data)
	return channel

func edit_guild_channel_positions(guild_id: int, params: Array) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_CHANNELS.format({guild_id = guild_id})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_guild_member(guild_id: int, user_id) -> Guild.Member:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_member_response(response, guild_id)

func list_guild_members(guild_id: int, limit: int = 1, after: int = 0) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBERS.format({guild_id = guild_id})
		+ "?limit=" + str(limit)
		+ "&after=" + str(after)
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_members_list_response(response, guild_id)

func search_guild_members(guild_id: int, query: String, limit: int = 1) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBERS_SEARCH.format({guild_id = guild_id})
		+ "?query=" + query.http_escape()
		+ "&limit=" + str(limit)
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_guild_members_list_response(response, guild_id)

func add_guild_member(guild_id: int, user_id: int, params: Dictionary) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).json_body(params).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	var is_added: bool = response.code == HTTPClient.RESPONSE_CREATED
	var member: Guild.Member = _handle_guild_member_response(response, guild_id)
	return [is_added, member]

func edit_guild_member(guild_id: int, user_id: int, params: Dictionary = {}) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	var error: int = OK if response.code == HTTPClient.RESPONSE_OK else FAILED
	var member: Guild.Member = _handle_guild_member_response(response, guild_id)
	return [error, member]

func edit_current_member(guild_id: int, params: Dictionary = {}) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.CURRENT_MEMBER.format({guild_id = guild_id})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	var error: int = OK if response.code == HTTPClient.RESPONSE_OK else FAILED
	var member: Guild.Member = _handle_guild_member_response(response, guild_id)
	return [error, member]

func add_guild_member_role(guild_id: int, user_id: int, role_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER_ROLE.format({
			guild_id = guild_id,
			user_id = user_id,
			role_id = role_id
		})
	).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func remove_guild_member_role(guild_id: int, user_id: int, role_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER_ROLE.format({
			guild_id = guild_id,
			user_id = user_id,
			role_id = role_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func remove_guild_member(guild_id: int, user_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_MEMBER.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_guild_bans(guild_id: int) -> Array:
	var bans: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_BANS.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var bans_data: Array = parse_json(response.body.get_string_from_utf8())
		for ban_data in bans_data:
			var user_id: int = ban_data["user"]["id"] as int
			var user: User = entity_manager.get_user(user_id)
			if not user:
				user = entity_manager.user_manager.construct_user(ban_data["user"])
			var reason: String = Dictionaries.get_non_null(ban_data, "reason", "")
			var ban: GuildBan = GuildBan.new(reason, user)
			bans.append(ban)
	return bans

func get_guild_ban(guild_id: int, user_id: int) -> GuildBan:
	var ban: GuildBan = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_BAN.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var ban_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		var user: User = entity_manager.get_user(user_id)
		if not user:
			user = entity_manager.user_manager.construct_user(ban_data["user"])
		var reason: String = Dictionaries.get_non_null(ban_data, "reason", "")
		ban = GuildBan.new(reason, user)
	return ban

func create_guild_ban(guild_id: int, user_id: int, params: Dictionary) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_BAN.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).json_body(params).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func remove_guild_ban(guild_id: int, user_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_BAN.format({
			guild_id = guild_id,
			user_id = user_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_guild_roles(guild_id: int) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_ROLES.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_roles_response(response, guild_id)

func create_guild_role(guild_id: int, params: Dictionary) -> Guild.Role:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_ROLES.format({guild_id = guild_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_role_response(response, guild_id)

func edit_guild_role_positions(guild_id: int, params: Array) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_ROLES.format({guild_id = guild_id})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_roles_response(response, guild_id)

func edit_guild_role(guild_id: int, role_id: int, params: Dictionary = {}) -> Guild.Role:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_ROLE.format({
			guild_id = guild_id,
			role_id = role_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_role_response(response, guild_id)

func delete_guild_role(guild_id: int, role_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_ROLE.format({
			guild_id = guild_id,
			role_id = role_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func get_guild_prune_count(guild_id: int, days: int = 7, include_roles: PoolStringArray = []) -> int:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_PRUNE.format({guild_id = guild_id})
		+ "?days=" + days
		+ ("&include_roles=" + include_roles.join(",")) if include_roles else ""
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var body: Dictionary = parse_json(response.body.get_string_from_utf8())
		return body["pruned"]
	return -1

func begin_guild_prune(guild_id: int, params: Dictionary) -> int:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_PRUNE.format({guild_id = guild_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var body: Dictionary = parse_json(response.body.get_string_from_utf8())
		return Dictionaries.get_non_null(body, "pruned", 0)
	return -1

func get_guild_voice_regions(guild_id: int) -> Array:
	var regions: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_VOICE_REGIONS.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var regions_data: Array = parse_json(response.body.get_string_from_utf8())
		for region_data in regions_data:
			var id: String = region_data["id"]
			var name: String = region_data["name"]
			var vip: bool = region_data["vip"]
			var optimal: bool = region_data["optimal"]
			var deprecated: bool = region_data["deprecated"]
			var custom: bool = region_data["custom"]
			var region: = DiscordVoiceRegion.new(id, name, vip, optimal, deprecated, custom)
			regions.append(region)
	return regions

func get_guild_invites(guild_id: int) -> Array:
	var invites: Array = []
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_INVITES.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var invites_data: Array = parse_json(response.body.get_string_from_utf8())
		for invite_data in invites_data:
			var invite: Guild.Invite = entity_manager.guild_manager.construct_invite(invite_data)
			invites.append(invite)
	return invites

func get_guild_integrations(guild_id: int) -> Array:
	return []

func delete_guild_integration(guild_id: int, integration_id: int) -> bool:
	return false

func get_guild_widget_settings(guild_id: int) -> Object:
	return null

func edit_guild_widget_settings(guild_id: int, params: Dictionary) -> Object:
	return null

func get_guild_widget(guild_id: int) -> Object:
	return null

func get_guild_vanity_url(guild_id: int) -> Guild.Invite:
	var invite: Guild.Invite = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_VANITY_URL.format({guild_id = guild_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		var invite_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		if Dictionaries.has_non_null(invite_data, "code"):
			invite = entity_manager.guild_manager.construct_invite(invite_data)
	return invite

func get_guild_widget_image(guild_id: int, style: String = "shield") -> Texture:
	var widget_image: Texture = null
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_WIDGET_IMAGE.format({guild_id = guild_id})
		+ "?style=" + style.http_escape()
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	if response.successful():
		widget_image = ImageTexture.new()
		var image: Image = Image.new()
		if image.load_png_from_buffer(response.body) == OK:
			widget_image.create_from_image(image)
	return widget_image

func get_guild_welcome_screen(guild_id: int) -> WelcomeScreen:
	return null

func edit_guild_welcome_screen(guild_id: int, params: Dictionary = {}) -> WelcomeScreen:
	return null

func edit_current_user_voice_state(guild_id: int, params: Dictionary) -> void:
	pass

func edit_user_voice_state(guild_id: int, user_id: int, params: Dictionary) -> void:
	pass

func _handle_guild_response(response: HTTPResponse) -> Guild:
	var guild: Guild = null
	if response.successful():
		var guild_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		guild = entity_manager.get_or_construct_guild(guild_data)
	return guild

func _handle_guild_member_response(response: HTTPResponse, guild_id: int) -> Guild.Member:
	var member: Guild.Member = null
	if response.successful():
		var member_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		member_data["guild_id"] = guild_id
		member = entity_manager.get_or_construct_guild_member(member_data)
	return member

func _handle_guild_members_list_response(response: HTTPResponse, guild_id: int) -> Array:
	var members: Array = []
	if response.successful():
		var members_data: Array = parse_json(response.body.get_string_from_utf8())
		for member_data in members_data:
			member_data["guild_id"] = guild_id
			var member: Guild.Member = entity_manager.get_or_construct_guild_member(member_data)
			members.append(member)
	return members

func _handle_role_response(response: HTTPResponse, guild_id: int) -> Guild.Role:
	var role: Guild.Role = null
	if response.successful():
		var role_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		role = _handle_role_body(role_data, guild_id)
	return role

func _handle_roles_response(response: HTTPResponse, guild_id: int) -> Array:
	var roles: Array = []
	if response.successful():
		var roles_data: Array = parse_json(response.body.get_string_from_utf8())
		for role_data in roles_data:
			role_data["guild_id"] = guild_id
			var role: Guild.Role = _handle_role_body(role_data, guild_id)
			roles.append(role)
	return roles

func _handle_role_body(role_data: Dictionary, guild_id: int) -> Guild.Role:
	var role: Guild.Role = null
	var role_id: int = role_data["id"] as int
	var guild: Guild = entity_manager.get_guild(guild_id)
	if guild:
		role = guild.get_role(role_id)
		entity_manager.guild_manager.update_role(role, role_data)
	if not role:
		role = entity_manager.guild_manager.construct_role(role_data)
		if guild:
			guild._roles[role_id] = role
	return role
