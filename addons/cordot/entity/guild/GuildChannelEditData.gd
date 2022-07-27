class_name GuildChannelEditData

# warning-ignore-all:return_value_discarded

var _data: Dictionary:
	get = to_dict

func set_name(name: String) -> GuildChannelEditData:
	_data["name"] = name
	return self

func set_position(position: int) -> GuildChannelEditData:
	_data["position"] = position
	return self

func set_overwrites(overwrites: Array) -> GuildChannelEditData:
	_data["permission_overwrites"] = overwrites
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "GuildChannelEditData"

func __set(_value) -> void:
	pass
