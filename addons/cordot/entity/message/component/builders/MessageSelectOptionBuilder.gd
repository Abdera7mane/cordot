# Helper class to build message select menu options.
class_name MessageSelectOptionBuilder

# Maximum number of characters in text fields.
const MAX_CHARACTERS: int = 100

var _data: Dictionary setget __set

# Constructs a new `MessageSelectOptionBuilder` with a `label` and `value`.
func _init(label: String, value: String) -> void:
	if label.length() > MAX_CHARACTERS or value.length() > MAX_CHARACTERS:
		push_error("Select option label and value max length is limited to %s" % MAX_CHARACTERS)
	else:
		_data["label"] = label
		_data["value"] = value

# Sets an additional description of the option.
func with_descriptions(description: String) -> MessageSelectOptionBuilder:
	if description.length() > MAX_CHARACTERS:
		push_error("Select option description max length is limited to %d" % MAX_CHARACTERS)
	else:
		_data["description"] = description
	return self

# Sets an `emoji` for the option.
func with_emoji(emoji: Emoji) -> MessageSelectOptionBuilder:
	_data["emoji"] = {
		id = null if emoji is UnicodeEmoji else emoji.id,
		name = emoji.name,
		animated = emoji.is_animated if emoji is Guild.GuildEmoji else false
	}
	return self

# Renders this option as selected by default.
func default(value: bool) -> MessageSelectOptionBuilder:
	_data["default"] = value
	return self

# Returns the select menu option data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageSelectOptionBuilder"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
