class_name BaseGuildManager

func construct_guild(_data: Dictionary) -> Guild:
	return null

func construct_guild_member(_data: Dictionary) -> Guild.Member:
	return null

func construct_role(_data: Dictionary) -> Guild.Role:
	return null

func construct_invite(_data: Dictionary) -> Guild.Invite:
	return null

func construct_guild_scheduled_event(_data: Dictionary) -> Guild.GuildScheduledEvent:
	return null

func construct_voice_state(_data: Dictionary) -> Guild.VoiceState:
	return null

func update_guild(_guild: Guild, _data: Dictionary) -> void:
	pass

func update_guild_member(_member: Guild.Member, _data: Dictionary) -> void:
	pass

func update_role(_role: Guild.Role, _data: Dictionary) -> void:
	pass

func update_voice_state(_state: Guild.VoiceState, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseGuildManager"
