# Helper class to build number options for a slash command.
class_name ApplicationCommandNumberOption extends ApplicationCommandChoicesBuilder

# Minumum value a user can input.
var min_value: float = NAN setget __set

# Maximum value a user can input.
var max_value: float = NAN setget __set

# Constructs a new number option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.NUMBER

# Adds a number choice.
func add_choice(name: String, value: float, localizations := {}) -> ApplicationCommandNumberOption:
	_add_choice({name = name, value = value, name_localizations = localizations})
	return self

# Sets the minimum value of the option.
func set_min(value: float) -> ApplicationCommandNumberOption:
	min_value = value
	return self

# Sets the maximum value of the option.
func set_max(value: float) -> ApplicationCommandNumberOption:
	max_value = value
	return self

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	if not is_nan(min_value):
		data["min_value"] = min_value
	if not is_nan(max_value):
		data["max_value"] = max_value
	return data

# doc-hide
func get_class() -> String:
	return "ApplicationCommandNumberOption"

func __set(_value) -> void:
	pass
