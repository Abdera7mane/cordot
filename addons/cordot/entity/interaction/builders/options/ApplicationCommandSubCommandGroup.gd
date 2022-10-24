# Helper class to build sub-command options to group sub-commands 
# for a slash command.
class_name ApplicationCommandSubCommandGroup extends ApplicationCommandOptionBuilder

# List of `ApplicationCommandOptionBuilder`s.
var options: Array setget __set

# Constructs new command sub-command option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.SUB_COMMAND_GROUP

# Adds a sub-command option.
func add_subcommand(name: String) -> ApplicationCommandSubCommand:
	var option := ApplicationCommandSubCommand.new(name)
	options.append(option)
	return option

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	var _options: Array = []
	for option in options:
		_options.append(option.build())
	data["options"] = _options
	# warning-ignore:return_value_discarded
	data.erase("required")
	return data

func get_class() -> String:
	return "ApplicationCommandSubCommandGroup"

func __set(_value) -> void:
	pass
