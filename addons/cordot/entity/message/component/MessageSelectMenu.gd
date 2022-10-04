# Interactive component that displays a list of options.
# They single-select and multi-select behavior.
class_name MessageSelectMenu extends MessageInteractiveComponent

# Disable the select.
var disabled: bool      setget __set

# List of `MessageSelectOption`s.
var options: Array      setget __set

# Custom placeholder text if nothing is selected.
var placeholder: String setget __set

# The minimum number of items that must be chosen.
var min_values: int     setget __set

# The maximum number of items that can be chosen.
var max_values: int     setget __set

# doc-hide
func _init(data: Dictionary).(data["custom_id"]) -> void:
	type = Type.SELECT_MENU
	options = data["options"]
	placeholder = data.get("placeholder", "")
	min_values = data.get("min_values", 1)
	max_values = data.get("max_values", 1)
	disabled = data.get("disabled", false)

# doc-hide
func get_class() -> String:
	return "MessageSelectMenu"

func __set(_value) -> void:
	pass
