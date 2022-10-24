# Helper class to build string options for a slash command.
class_name ApplicationCommandStringOption extends ApplicationCommandChoicesBuilder

# Constructs a new string option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.STRING

# Adds a string choice to the option.
func add_choice(name: String, value: String, localizations := {}) -> ApplicationCommandStringOption:
	_add_choice({name = name, value = value, name_localizations = localizations})
	return self

# doc-hide
func get_class() -> String:
	return "ApplicationCommandStringOption"
