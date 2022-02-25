class_name RolePositionsEditData

# warning-ignore-all:return_value_discarded

var _data: Array setget __set, to_array

func add_role(id: int, position: int) -> RolePosition:
	var role_position: RolePosition = RolePosition.new(id, position)
	_data.append(role_position)
	return role_position

func to_array() -> Array:
	var data: Array = []
	for role_position in _data:
		data.append(role_position.to_dict())
	return data

func get_class() -> String:
	return "RolePositionsEditData"

func __set(_value) -> void:
	pass

class RolePosition:
	var _data: Dictionary setget __set, to_dict
	
	func _init(id: int, position: int) -> void:
		_data["id"] = str(id)
		set_position(position)
	
	func set_position(position: int) -> RolePosition:
		_data["position"] = position
		return self
	
	func get_class() -> String:
		return "RolePositionsEditData.RolePosition"
	
	func to_dict() -> Dictionary:
		return _data.duplicate()
	
	func __set(_value) -> void:
		pass
