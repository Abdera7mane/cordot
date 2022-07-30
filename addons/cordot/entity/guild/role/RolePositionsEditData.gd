class_name RolePositionsEditData

var _data: Array

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

class RolePosition:
	var _data: Dictionary
	
	@warning_ignore(return_value_discarded)
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
