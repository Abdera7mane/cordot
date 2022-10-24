# Helper class to build sub-command options for a slash command.
class_name ApplicationCommandSubCommand extends ApplicationCommandOptionBuilder

# List of `ApplicationCommandOptionBuilder`s.
var options: Array setget __set

# Constructs a new sub-command option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.SUB_COMMAND

# Adds a command option, can not be a a sub-command group or an other subcomand.
func add_option(option: ApplicationCommandOptionBuilder) -> ApplicationCommandSubCommand:
	if options.size() > 0 and not options[-1].required and option.required:
			push_error("'required=true' command options must be added first")
	else:
		options.append(option)
	return self

# Adds a string option.
func add_string_option(option_name: String) -> ApplicationCommandStringOption:
	var option := ApplicationCommandStringOption.new(option_name)
	options.append(option)
	return option

# Adds an integer option.
func add_integer_option(option_name: String) -> ApplicationCommandIntegerOption:
	var option := ApplicationCommandIntegerOption.new(option_name)
	options.append(option)
	return option

# Adds an boolean option.
func add_boolean_option(option_name: String) -> ApplicationCommandBoolOption:
	var option := ApplicationCommandBoolOption.new(option_name)
	options.append(option)
	return option

# Adds a user option.
func add_user_option(option_name: String) -> ApplicationCommandUserOption:
	var option := ApplicationCommandUserOption.new(option_name)
	options.append(option)
	return option

# Adds a channel option.
func add_channel_option(option_name: String) -> ApplicationCommandChannelOption:
	var option := ApplicationCommandChannelOption.new(option_name)
	options.append(option)
	return option

# Adds a channel option.
func add_role_option(option_name: String) -> ApplicationCommandRoleOption:
	var option := ApplicationCommandRoleOption.new(option_name)
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

# doc-hide
func get_class() -> String:
	return "ApplicationCommandSubCommand"

func __set(_value) -> void:
	pass
