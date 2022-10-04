# Represents a component that can be interacted with.
class_name MessageInteractiveComponent extends MessageComponent

# Component identifier.
var custom_id: String setget __set

# doc-hide
func _init(id: String) -> void:
	custom_id = id

# doc-hide
func get_class() -> String:
	return "MessageInteractiveComponent"

func __set(_value) -> void:
	pass
