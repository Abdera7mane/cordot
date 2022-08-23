# doc-hide
class_name GuildPacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"GUILD_CREATE": "_on_guild_create",
	"GUILD_UPDATE": "_on_guild_update",
	"GUILD_DELETE": "_on_guild_delete",
	"GUILD_BAN_ADD": "_on_guild_ban_add",
	"GUILD_BAN_REMOVE": "_on_guild_ban_remove",
	"GUILD_EMOJIS_UPDATE": "_on_guild_emojis_update",
	"GUILD_MEMBER_ADD": "_on_guild_member_add",
	"GUILD_MEMBER_REMOVE": "_on_guild_member_remove",
	"GUILD_MEMBER_UPDATE": "_on_guild_member_update",
	"GUILD_ROLE_CREATE": "_on_guild_role_create",
	"GUILD_ROLE_UPDATE": "_on_guild_role_update",
	"GUILD_ROLE_DELETE": "_on_guild_role_delete",
	"INVITE_CREATE": "_on_invite_create",
	"INVITE_DELETE": "_on_invite_delete",
	"VOICE_STATE_UPDATE": "_on_voice_state_update"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

func _on_guild_create(fields: Dictionary) -> void:
	var guild_id: int = fields["id"] as int
	var guild: Guild = _entity_manager.get_guild(guild_id)
	if guild and !guild.unavailable == fields["unavailable"]:
		_entity_manager.guild_manager.update_guild(guild, fields)
		return
	
	guild = _entity_manager.get_or_construct_guild(fields)
	self.emit_signal("transmit_event", "guild_created", [guild])

func _on_guild_update(fields: Dictionary) -> void:
	var guild: Guild = _entity_manager.get_guild(fields["id"] as int)
	if guild:
		var old: Guild = guild.clone()
		_entity_manager.guild_manager.update_guild(guild, fields)
		self.emit_signal("transmit_event", "guild_updated", [old, guild])

func _on_guild_delete(fields: Dictionary) -> void:
	var id: int = fields["id"] as int
	var guild: Guild = _entity_manager.get_guild(id)
	if guild:
		if fields.has("unavailable"):
			self.emit_signal("transmit_event", "guild_unavailable", [guild])
			guild._update({unavailable = true})
		else:
			_entity_manager.remove_guild(id)
			self.emit_signal("transmit_event", "guild_updated", [guild])

func _on_guild_ban_add(fields: Dictionary) -> void:
	var guild: Guild = _entity_manager.get_guild(fields["guild_id"])
	var user: User = _entity_manager.get_or_construct_user(fields["user"], false)
	if guild:
		emit_signal("transmit_event", "guild_ban_added", [guild, user])

func _on_guild_ban_remove(fields: Dictionary) -> void:
	var guild: Guild = _entity_manager.get_guild(fields["guild_id"])
	var user: User = _entity_manager.get_or_construct_user(fields["user"], false)

	if guild:
		emit_signal("transmit_event", "guild_ban_removed", [guild, user])

func _on_guild_emojis_updated(fields: Dictionary) -> void:
	var guild: Guild = _entity_manager.get_guild(fields["guild_id"] as int)
	if guild:
		var emojis: Array = []
		for emoji_data in fields["emojis"]:
			emojis.append(_entity_manager.get_or_construct_emoji(emoji_data))
		
		guild._update({emojis = emojis})
		emit_signal("transmit_event", "guild_emojis_updated", [guild, emojis])

func _on_guild_member_add(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	fields["guild_id"] = guild_id
	var guild: Guild = _entity_manager.get_guild(guild_id)
	
	if guild:
		guild._update({member_count = guild.member_count + 1})

		var member: Guild.Member = _entity_manager.get_or_construct_guild_member(fields, true)
		emit_signal("transmit_event", "member_joined", [guild, member])

func _on_guild_member_remove(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	fields["guild_id"] = guild_id
	var guild: Guild = _entity_manager.get_guild(guild_id)
	
	if guild:
		guild._update({member_count = guild.member_count - 1})

		var user: User = _entity_manager.get_or_construct_user(fields["user"], false)
		var member: Guild.Member = guild.get_member(user.id)
		if guild._members.erase(user.id):
			emit_signal("transmit_event", "member_left", [guild, member])

func _on_guild_member_update(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	fields["guild_id"] = guild_id
	var member_id: int = fields["user"]["id"] as int
	
	var guild: Guild = _entity_manager.get_guild(guild_id)
	if guild:
		var member: Guild.Member = guild.get_member(member_id)
		if member:
			var old: Guild.Member = member.clone()
			_entity_manager.guild_manager.update_guild_member(member, fields)
			emit_signal("transmit_event", "member_updated", [guild, old, member])
			
		else:
			member = _entity_manager.get_or_construct_guild_member(fields, true)

func _on_guild_role_create(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	fields["guild_id"] = guild_id
	var guild: Guild = _entity_manager.get_guild(guild_id)

	if guild:
		var role: Guild.Role = _entity_manager.guild_manager.construct_role(fields)
		guild._roles[role.id] = role
		emit_signal("transmit_event", "guild_role_created", [guild, role])


func _on_guild_role_update(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	fields["guild_id"] = guild_id
	var guild: Guild = _entity_manager.get_guild(guild_id)
	var role_data: Dictionary = fields["role"]
	var role_id: int = role_data["id"] as int
	role_data["guild_id"] = guild_id
	
	if guild:
		var role: Guild.Role = guild.get_role(role_id)
		if role:
			var old: Guild.Role = role.clone()
			_entity_manager.guild_manager.update_role(role, fields["role"])
			emit_signal("transmit_event", "guild_role_updated", [guild, old, role])
		else:
			role = _entity_manager.guild_manager.construct_role(fields)
			guild._roles[role_id] = role

func _on_guild_role_delete(fields: Dictionary) -> void:
	var guild_id: int = fields["guild_id"] as int
	var guild: Guild = _entity_manager.get_guild(guild_id)
	var role_id: int = fields["role_id"] as int
	
	if guild:
		var role: Guild.Role = guild.get_role(role_id)
		if guild._roles.erase(role_id):
			emit_signal("transmit_event", "guild_role_deleted", [guild, role])

func _on_voice_state_update(fields: Dictionary) -> void:
	var user_id: int = fields["user_id"] as int
	var guild_id: int = fields["guild_id"] as int
	var guild: Guild = _entity_manager.get_guild(guild_id)
	var member: Guild.Member = guild.get_member(user_id)
	var state: Guild.VoiceState = guild.voice_states.get(user_id)
	
	if member:
		member._update({
			is_deafened = fields["deaf"],
			is_muted = fields["mute"],
		})
	
	if state:
		if not Dictionaries.has_non_null(fields, "channel_id"):
			# warning-ignore:return_value_discarded
			guild.voice_states.erase(user_id)
		var old: Guild.VoiceState = state.clone()
		_entity_manager.guild_manager.update_voice_state(state, fields)
		emit_signal("transmit_event", "voice_state_updated", [old, state])
	
	elif member:
		var old: Guild.VoiceState = member.get_voice_state()
		state = _entity_manager.get_or_construct_voice_state(fields)
		guild.voice_states[user_id] = state
		emit_signal("transmit_event", "voice_state_updated", [old, state])

func get_class() -> String:
	return "GuildPacketsHandler"
