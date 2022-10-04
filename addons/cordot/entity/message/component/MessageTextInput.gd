# Interactive component that renders on modals.
# They can be used to collect short-form or long-form text.
class_name MessageTextInput extends MessageInteractiveComponent

# Text input styles.
enum Styles {
	SHORT     = 1,
	PARAGRAPH = 2,
}

# Style of text input.
var style: int          setget __set

# The label for this component.
var label: String       setget __set

# The minimum input length for a text input.
var min_length: int     setget __set

# The maximum input length for a text input.
var max_length: int     setget __set

# Whether this component is required to be filled,
var required: bool      setget __set

# A pre-filled value for this component.
var value: String       setget __set

# Custom placeholder text if the input is empty.
var placeholder: String setget __set

# doc-hide
func _init(data: Dictionary).(data["custom_id"]) -> void:
	type = Type.TEXT_IPUT
	style = data["style"]
	label = data["label"]
	min_length = data.get("min_length", 4000)
	max_length = data.get("max_length", 4000)
	required = data.get("required", true)
	value = data.get("value", "")
	placeholder = data.get("placeholder", "")

# doc-hide
func get_class() -> String:
	return "MessageTextInput"

func __set(_value) -> void:
	pass
