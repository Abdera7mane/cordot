class_name Member extends MentionableEntity


var user: User: # Make this variable of type `User`
	get = get_user
var nickname: String:
	get = get_nickname
var avatar_hash: String:
	get = get_avatar_hash
var guild_id: int
var guild: Guild: # Make this variable of type `Guild`
	get = get_guild
var roles_ids: Array
var roles: Array:
	get = get_roles
var presence: Presence: # Make this variable of type `Presence`
	get = get_presence
var join_date: int
var premium_since: int
var is_deafened: bool
var is_muted: bool
var pending: bool

func _init(data: Dictionary) -> void:
	super(data["id"])
	guild_id = data["guild_id"]
	join_date = data["join_date"]
	_update(data)

func get_guild() -> Guild:
	return self.get_container().guilds.get(guild_id)

func get_mention() -> String:
	return self.user.get_mention()

func get_nickname_mention() -> String:
	return self.user.get_nickname_mention()

func get_nickname() -> String:
	return self.user.username if nickname.is_empty() else nickname

func get_avatar_hash() -> String:
	return avatar_hash if not avatar_hash.is_empty() else self.user.avatar_hash

func get_roles() -> Array:
	var _roles: Array
	for role_id in self.roles_ids:
		var role: Role = self.guild.get_role(role_id)
		if role:
			_roles.append(role)
	return _roles

func get_user() -> User:
	return (self.get_container().users.get(self.id))

func get_presence() -> Presence:
	return self.get_container().presences.get(self.id)

func get_partial_voice_state() -> VoiceState:
	var state: VoiceState = VoiceState.new({
		user_id = self.id,
		guild_id = guild_id,
		is_deafened = is_deafened,
		is_muted = is_muted
	})
	state.set_meta("partial", true)
	return state

func get_voice_state() -> VoiceState:
	if self.guild.voice_states.has(self.id):
		return guild.voice_states[self.id]
	return get_partial_voice_state()

func get_permissions() -> BitFlag:
	var _enum: Dictionary = (Permissions as Script).get_script_constant_map()
	# warning-ignore:narrowing_conversion
	var all: int = pow(2, _enum.size()) - 1

	var permissions: BitFlag
	if is_owner():
		permissions = BitFlag.new(_enum)
		permissions.flags = all
	else:
		var default_role: Role = self.guild.get_default_role()
		permissions = default_role.permissions.clone()
		for role in self.roles:
			# warning-ignore:return_value_discarded
			permissions.put(role.permissions.flags)
		if permissions.has(Permissions.ADMINISTRATOR):
			permissions.flags = all
	return permissions

func permissions_in(channel_id: int) -> BitFlag:
	var base_permissions: BitFlag = get_permissions()
	if base_permissions.ADMINISTRATOR:
		return base_permissions

	var permissions: BitFlag = base_permissions.clone()

	var channel: Channel = self.guild.get_channel(channel_id)
	if not channel:
		push_error("Channel with id '%d' was not found in guild with id '%d'" % [channel_id, guild_id])
		return permissions

	var default_overwrite: PermissionOverwrite = channel.overwrites.get(guild_id)
	if default_overwrite:
		# warning-ignore:return_value_discarded
		permissions.clear(default_overwrite.deny.flags)\
					.put(default_overwrite.allow.flags)

	var allow: int = 0
	var deny: int = 0
	for role_id in roles_ids:
		var overwrite: PermissionOverwrite = channel.overwrites.get(role_id)
		if overwrite:
			allow |= overwrite.allow.flags
			deny |= overwrite.deny.flags

	# warning-ignore:return_value_discarded
	permissions.clear(deny).put(allow)

	var member_overwrite: PermissionOverwrite = channel.overwrites.get(self.id)
	if member_overwrite:
		# warning-ignore:return_value_discarded
		permissions.clear(member_overwrite.deny.flags)\
					.put(member_overwrite.allow.flags)

	return permissions

func is_owner() -> bool:
	return self.guild.owner_id == self.id

func has_role(id: int) -> bool:
	return id in self.roles_ids

func edit(data: GuildMemberEditData) -> Member:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()

	var fail: bool = false
	if data.has("nick") and not self_permissions.MANAGE_NICKNAMES:
		push_error("Can not edit member nickname, missing MANAGE_NICKNAMES permission")
		fail = true
	if data.has("roles") and not self_permissions.MANAGE_ROLES:
		push_error("Can not edit member roles, missing MANAGE_ROLES permission")
		fail = true
	if data.has("mute") and not self_permissions.MUTE_MEMBERS:
		push_error("Can not mute member, missing MUTE_MEMBERS permission")
		fail = true
	if data.has("deaf") and not self_permissions.DEAFEN_MEMBERS:
		push_error("Can not deafen member, missing DEAFEN_MEMBERS permission")
		fail = true
	if data.has("channel_id") and not self_permissions.MOVE_MEMBERS:
		push_error("Can not move member, missing MOVE_MEMBERS permission")
		fail = true
	if data.has("communication_disabled_until") and not self_permissions.MODERATE_MEMBERS:
		push_error("Can not timeout member, missing MODERATE_MEMBERS permission")
		fail = true
	if fail:
		return await Awaiter.submit()

	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_member", [guild_id, self.id, data.to_dict()]
	)

func assign_role(role_id: int) -> bool:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()

	var fail: bool = false
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not assign role, missing MANAGE_ROLES permission")
		fail = true
	elif has_role(role_id):
		push_error("Member already has the role '%d'" % role_id)
		fail = true
	elif self.guild._roles.has(role_id):
		push_error("Role with id '%d' does not exist in guild '%d'" % [role_id, guild_id])
		fail = true
	if fail:
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"add_guild_member_role", [guild_id, self.id, role_id]
	)

func revoke_role(role_id: int) -> bool:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()

	var fail: bool = false
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not revoke role, missing MANAGE_ROLES permission")
		fail = true
	elif not has_role(role_id):
		push_error("Member does not have role with '%d', can not revoke it" % role_id)
		fail = true
	elif self.guild._roles.has(role_id):
		push_error("Role with id '%d' does not exist in guild '%d'" % [role_id, guild_id])
		fail = true
	if fail:
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"remove_guild_member_role", [guild_id, self.id, role_id]
	)

func kick() -> bool:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
	if not self_permissions.KICK_MEMBERS:
		push_error("Can not kick member, missing KICK_MEMBERS permission")
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"remove_guild_member", [guild_id, self.id]
	)

func ban() -> bool:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
	if not self_permissions.BAN_MEMBERS:
		push_error("Can not ban member, missing BAN_MEMBERS permission")
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"create_guild_ban", [guild_id, self.id]
	)

func _update_presence(_presence: Presence) -> void:
	presence = _presence

func get_class() -> String:
	return "Guild.Member"

func _clone_data() -> Array:
	return [{
		id = self.id,
		nickname = nickname,
		avatar_hash = avatar_hash,
		guild_id = self.guild_id,
		role_ids = self.roles_ids.duplicate(),
		join_date = self.join_date,
		premium_since = self.premium_since,
		is_deafened = self.is_deafened,
		is_muted = self.is_muted,
		pending = self.pending
	}]

func _update(data: Dictionary) -> void:
	nickname = data.get("nickname", nickname)
	avatar_hash = data.get("nickname", avatar_hash)
	roles_ids = data.get("roles_ids", roles_ids)
	premium_since = data.get("premium_since", premium_since)
	is_deafened = data.get("is_deafened", is_deafened)
	is_muted = data.get("is_muted", is_muted)
	pending = data.get("pending", pending)

#	func __set(_value) -> void:
#		pass
