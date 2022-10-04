# Helper class to build message text inputs (only availabe to Modals).
class_name MessageTextInputBuilder extends MessageComponentBuilder

# Maximum number of characters in a text input label.
const LABEL_MAX_LENGTH: int = 45

# Maximum number of characters in a text input.
const INPUT_MAX_LENGTH: int = 4000

# Maximum number of characters in a text input placeholder.
const PLACEHOLDER_MAX_LENGTH: int = 100

# Default maximum input length.
const MAX_VALUES: int = INPUT_MAX_LENGTH

# Default minimum input length.
const MIN_VALUES: int = 0

# Constructs a new `MessageTextInputBuilder` instance with a `custom_id` 
# and `label` text.
func _init(custom_id: String, label: String).(custom_id, MessageComponent.Type.TEXT_IPUT) -> void:
	_data["style"] = MessageTextInput.Styles.SHORT
	if label.length() > LABEL_MAX_LENGTH:
		push_error("Text input label max length is limited to %d" % LABEL_MAX_LENGTH)
	else:
		_data["label"] = label

# Pre-fills an input value.
func with_value(value: String) -> MessageTextInputBuilder:
	if value.length() > INPUT_MAX_LENGTH:
		push_error("Text input value max length is limited to %d" % INPUT_MAX_LENGTH)
	else:
		_data["value"] = value
	return self

# Sets a placeholder text to show if the input is empty.
func with_placeholder(placeholder: String) -> MessageTextInputBuilder:
	if placeholder.length() > PLACEHOLDER_MAX_LENGTH:
		push_error("Text input placeholder max length is limited to %d" % PLACEHOLDER_MAX_LENGTH)
	else:
		_data["placeholder"] = placeholder
	return self

# Sets the minimum input length.
func min_values(min_values: int) -> MessageTextInputBuilder:
	if min_values < MIN_VALUES and min_values > MAX_VALUES:
		push_error("Text input max values must be between %d and %d" % [MIN_VALUES, MAX_VALUES])
	else:
		_data["min_values"] = min_values
	return self

# Sets the maximum input length.
func max_values(max_values: int) -> MessageTextInputBuilder:
	if max_values > MAX_VALUES:
		push_error("Text input max values must be lower or equal to %d" % MAX_VALUES)
	else:
		_data["max_values"] = max_values
	return self

# Requires the text input to be filled, `true` by default.
func required(value: bool) -> MessageTextInputBuilder:
	_data["required"] = value
	return self

# doc-hide
func get_class() -> String:
	return "MessageTextInputBuilder"
