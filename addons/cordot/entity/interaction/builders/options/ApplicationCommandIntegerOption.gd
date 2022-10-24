# Helper class to build integer options for a slash command.
class_name ApplicationCommandIntegerOption extends ApplicationCommandChoicesBuilder

var _enable_max: bool setget __set
var _enable_min: bool setget __set

# Minumum value a user can input.
var min_value: int    setget __set

# Maximum value a user can input.
var max_value: int    setget __set

# Constructs a new integer option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.INTEGER

# Adds an integer choice.
func add_choice(name: String, value: int, localizations := {}) -> ApplicationCommandIntegerOption:
	_add_choice({name = name, value = value, name_localizations = localizations})
	return self

# Sets the minimum value of the option.
func set_min(value: int) -> ApplicationCommandIntegerOption:
	min_value = value
	_enable_min = true
	return self

# Sets the maximum value of the option.
func set_max(value: int) -> ApplicationCommandIntegerOption:
	max_value = value
	_enable_max = true
	return self

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	if _enable_min:
		data["min_value"] = min_value
	if _enable_max:
		data["max_value"] = max_value
	return data

# doc-hide
func get_class() -> String:
	return "ApplicationCommandIntegerOption"

func __set(_value) -> void:
	pass
