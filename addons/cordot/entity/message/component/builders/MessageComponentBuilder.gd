# Abstract Helper class to build message components.
class_name MessageComponentBuilder

# Maximum number of characters for a component identifier.
const ID_MAX_LENGTH: int = 100

var _data: Dictionary setget __set

# doc-hide
func _init(custom_id: String, type: int) -> void:	
	_data = {type = type}
	_set_custom_id(custom_id)

func _set_custom_id(custom_id: String) -> void:
	if custom_id.length() > ID_MAX_LENGTH:
		push_error("Message component custom id max length is limited to %s" % ID_MAX_LENGTH)
	elif not custom_id.empty():
		_data["custom_id"] = custom_id

# Returns the component data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageComponentBuilder"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
