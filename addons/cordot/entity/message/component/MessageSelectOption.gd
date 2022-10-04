# Represents an option of a Select Menu.
class_name MessageSelectOption

# Name of the option.
var label: String       setget __set

# Value of the option.
var value: String       setget __set

# Additional description of the option.
var description: String setget __set

# Option's emoji if present.
var emoji: Emoji        setget __set

# Whether this option is selected by default.
var default: bool       setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	label = data["label"]
	value = data["value"]
	description = data.get("description", "")
	emoji = data.get("emoji")
	default = data.get("default", false)

# doc-hide
func get_class() -> String:
	return "MessageSelectOption"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
