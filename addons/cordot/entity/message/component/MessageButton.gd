# Button message component.
#
# `custom_id` is empty when `url` is set, and the button does not fire an
# interaction event if it is the case.
class_name MessageButton extends MessageInteractiveComponent

# Button styles
enum Styles {
	PRIMARY = 1,
	SECONDARY,
	SUCCESS,
	DANGER,
	LINK,
}

# Whether the button is disabled.
var disabled: bool    setget __set

# Button style.
var style: int        setget __set

# The text that appears on the button.
var label: String     setget __set

# Button emoji if present.
var emoji: Emoji      setget __set

# Button URL, appliable when `style` is equal to `Styles.LINK`.
var url: String       setget __set

# doc-hide
func _init(data: Dictionary).(data.get("custom_id", "")) -> void:
	type = Type.BUTTON
	style = data["style"]
	label = data.get("label", "")
	emoji = data.get("emoji")
	url = data.get("url", "")
	disabled = data.get("disabled", false)

# doc-hide
func get_class() -> String:
	return "MessageButton"

func __set(_value) -> void:
	pass
