# Helper class to build message select menus.
#
# - Select menus must be sent inside an Action Row.
# - An Action Row can contain only one select menu.
# - An Action Row containing a select menu cannot also contain buttons.
class_name MessageSelectMenuBuilder extends MessageComponentBuilder

# Maximum number of options in a select menu.
const MAX_OPTIONS: int = 25

# Maximum number of characters in a text input placeholder.
const PLACEHOLDER_MAX_LENGTH: int = 150

# Maximum number of items that can be chosen.
const MAX_VALUES: int = 25

# Minimum number of items that can be chosen.
const MIN_VALUES: int = 0

# Constructs a new `MessageSelectMenuBuilder` instance with a `custom_id`.
func _init(custom_id: String).(custom_id, MessageComponent.Type.SELECT_MENU) -> void:
	_data["options"] = []

# Adds an `option` to the select menu.
func add_option(option: MessageSelectOptionBuilder) -> MessageSelectMenuBuilder:
	var options: Array = _data["options"]
	if options.size() < MAX_OPTIONS:
		options.append(option)
	else:
		push_error("Select menu options are limited to %d options" % MAX_OPTIONS)
	return self

# Sets a placeholder text to show if nothing is selected.
func with_placeholder(placeholder: String) -> MessageSelectMenuBuilder:
	if placeholder.length() > PLACEHOLDER_MAX_LENGTH:
		push_error("Select menu placeholder max length is limited to %d" % PLACEHOLDER_MAX_LENGTH)
	else:
		_data["placeholder"] = placeholder
	return self

# Sets the minimum number of items that must be chosen, default to `1`.
func min_values(min_values: int) -> MessageSelectMenuBuilder:
	if min_values < MIN_VALUES and min_values > MAX_VALUES:
		push_error("Select menu max values must be between %d and %d" % [MIN_VALUES, MAX_VALUES])
	else:
		_data["min_values"] = min_values
	return self

# Sets the maximum number of items that can be chosen, default to `1`.
func max_values(max_values: int) -> MessageSelectMenuBuilder:
	if max_values > MAX_VALUES:
		push_error("Select menu max values must be lower or equal to %d" % MAX_VALUES)
	else:
		_data["max_values"] = max_values
	return self

# Disables the select menu.
func disabled(value: bool) -> MessageSelectMenuBuilder:
	_data["disabled"] = value
	return self

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	var options: Array = []
	for option in data["options"]:
		options.append(option.build())
	data["options"] = options
	return data

# doc-hide
func get_class() -> String:
	return "MessageSelectMenuBuilder"
