class_name ChannelCreateData

# warning-ignore-all:return_value_discarded

var _data: Dictionary setget __set, to_dict

func _init(name: String) -> void:
	set_name(name)

func set_name(name: String) -> ChannelCreateData:
	name = name.strip_edges()
	if name.empty():
		push_error("Guild name can not be empty")
	_data["name"] = name
	return self

func set_type(type: int) -> ChannelCreateData:
	_data["type"] = type
	return self

func set_topic(topic: String) -> ChannelCreateData:
	_data["topic"] = topic
	return self

func set_bitrate(bitrate: int) -> ChannelCreateData:
	_data["bitrate"] = bitrate
	return self

func set_user_limit(user_limit: int) -> ChannelCreateData:
	_data["user_limit"] = user_limit
	return self

func set_rate_limit_per_user(limit: int) -> ChannelCreateData:
	_data["rate_limit_per_user"] = limit
	return self

func set_position(position: int) -> ChannelCreateData:
	_data["position"] = position
	return self

func set_permission_overwrites(overwrites: Array) -> ChannelCreateData:
	_data["permission_overwrites"] = overwrites
	return self

func set_parent(id: int) -> ChannelCreateData:
	_data["parent_id"] = str(id)
	return self

func set_nsfw(value: bool) -> ChannelCreateData:
	_data["nsfw"] = value
	return self

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "ChannelCreateData"

func __set(_value) -> void:
	pass
