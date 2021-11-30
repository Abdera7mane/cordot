class_name GuildPacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"GUILD_CREATE": "_on_guild_create",
	"GUILD_UPDATE": "_on_guild_update",
	"GUILD_DELETE": "_on_guild_delete",
	"GUILD_BAN_ADD": "_on_guild_ban_add",
	"GUILD_BAN_REMOVE": "_on_guild_ban_remove",
	"GUILD_EMOJIS_UPDATE": "_on_guild_emojis_update",
	"GUILD_INTEGRATIONS": "_on_guild_integrations_update",
	"GUILD_MEMBER_ADD": "_on_guild_member_add",
	"GUILD_MEMBER_REMOVE": "_on_guild_member_remove",
	"GUILD_MEMBER_UPDATE": "_on_guild_member_update",
	"GUILD_MEMBERs_CHUNK": "_on_guild_members_chunk",
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

# warning-ignore:unused_argument
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

# warning-ignore:unused_argument
func _on_guild_ban_add(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_ban_remove(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_emojis_updated(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_integrations_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_member_add(member_data: Dictionary) -> void:
	var _on_guild_id: int = member_data["guild_id"] as int

# warning-ignore:unused_argument
func _on_guild_member_remove(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_member_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_members_chunk(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_role_create(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_role_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_guild_role_delete(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_voice_state_update(fields) -> void:
	pass

func get_class() -> String:
	return "GuildPacketsHandler"
