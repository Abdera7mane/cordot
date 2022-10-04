# Helper class to build message buttons.
#
# - Buttons must be sent inside an Action Row.
# - An Action Row can contain up to 5 buttons.
# - An Action Row containing buttons cannot also contain a select menu.
class_name MessageButtonBuilder extends MessageComponentBuilder

# Maximum number of characters in a button label.
const LABEL_MAX_LENGTH: int = 80

# Constructs a new `MessageButtonBuilder` instance.
# `style` takes a `MessageButton.Styles` value.
func _init(style: int).("", MessageComponent.Type.BUTTON) -> void:
	_data["style"] = style

# Sets the button's label.
func with_label(label: String) -> MessageButtonBuilder:
	if label.length() > LABEL_MAX_LENGTH:
		push_error("Message component label max length is limited to %s" % LABEL_MAX_LENGTH)
	else:
		_data["label"] = label
	return self

# Sets the message identifier.
# Can not be specified if the message `style` is `MessageButton.Styles.LINK`.
func with_custom_id(custom_id: String) -> MessageButtonBuilder:
	if _data["style"] == MessageButton.Styles.LINK:
		push_error("Message button custom id can only be specified to non-link style buttons")
	else:
		_set_custom_id(custom_id)
	return self

# Sets the message URL.
# Can not be specified if the message `style` is not `MessageButton.Styles.LINK`.
func with_url(url: String) -> MessageButtonBuilder:
	if _data["style"] == MessageButton.Styles.LINK:
		_data["url"] = url
	else:
		push_error("Message button URL can only be specified to link style buttons")
	return self

# Disables the button.
func disabled(value: bool) -> MessageButtonBuilder:
	_data["disabled"] = value
	return self

# doc-hide
func get_class() -> String:
	return "MessageButtonBuilder"
