class_name GuildMemberEditData

# warning-ignore-all:return_value_discarded

var _data: Dictionary setget __set, to_dict

func set_nickname(nickname: String) -> GuildMemberEditData:
	_data["nick"] = nickname
	return self

func set_roles(roles: PoolStringArray) -> GuildMemberEditData:
	_data["roles"] = roles
	return self

func mute(value: bool) -> GuildMemberEditData:
	_data["mute"] = value
	return self

func deafen(value: bool) -> GuildMemberEditData:
	_data["deaf"] = value
	return self

func move_to_channel(channel_id: int) -> GuildMemberEditData:
	_data["channel_id"] = str(channel_id)
	return self

func timeout(until: int) -> GuildMemberEditData:
	_data["communication_disabled_until"] = TimeUtil.unix_to_iso(until)
	return self

func remove_nickname() -> GuildMemberEditData:
	_data["nick"] = null
	return self

func clear_roles() -> GuildMemberEditData:
	return set_roles([])

func remove_timeount() -> GuildMemberEditData:
	_data["communication_disabled_until"] = null
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "GuildMemberEditData"

func __set(_value) -> void:
	pass
