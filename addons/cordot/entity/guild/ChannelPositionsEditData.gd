class_name ChannelPositionsEditData

# warning-ignore-all:return_value_discarded

var _data: Array:
	get = to_array

func add_channel(id: int) -> ChannelPosition:
	var channel_position: ChannelPosition = ChannelPosition.new(id)
	_data.append(channel_position)
	return channel_position

func to_array() -> Array:
	var data: Array = []
	for channel_position in _data:
		data.append(channel_position.to_dict())
	return data

func get_class() -> String:
	return "ChannelPositionsEditData"

func __set(_value) -> void:
	pass

class ChannelPosition:
	var _data: Dictionary:
		get = to_dict

	func _init(id: int) -> void:
		_data["id"] = str(id)

	func set_position(position: int) -> ChannelPosition:
		_data["position"] = position
		return self

	func syncs_permissions(value: bool) -> ChannelPosition:
		_data["lock_permissions"] = value
		return self

	func set_parent(id: int) -> ChannelPosition:
		_data["parent_id"] = str(id)
		return self

	func get_class() -> String:
		return "ChannelPositionsEditData.ChannelPosition"

	func to_dict() -> Dictionary:
		return _data.duplicate()

	func __set(_value) -> void:
		pass
