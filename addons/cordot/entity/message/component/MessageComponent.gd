# Abstract class for message components which are interactive elements
# in messages.
class_name MessageComponent

# Message component types.
enum Type {
	ACTION_ROW = 1,
	BUTTON,
	SELECT_MENU,
	TEXT_IPUT,
}

# Type of the component.
var type: int setget __set

# doc-hide
func get_class() -> String:
	return "MessageComponent"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
