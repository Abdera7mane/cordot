class_name ApplicationCommandSubCommand extends ApplicationCommandOptionBuilder

var options: Array

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.SUB_COMMAND

func add_option(option: ApplicationCommandOptionBuilder) -> ApplicationCommandSubCommand:
	if options.size() > 0 and not options[-1].required and option.required:
			push_error("'required=true' command options must be added first")
	else:
		options.append(option)
	return self

func add_string_option(option_name: String) -> ApplicationCommandStringOption:
	var option := ApplicationCommandStringOption.new(option_name)
	options.append(option)
	return option

func add_integer_option(option_name: String) -> ApplicationCommandIntegerOption:
	var option := ApplicationCommandIntegerOption.new(option_name)
	options.append(option)
	return option

func add_boolean_option(option_name: String) -> ApplicationCommandBoolOption:
	var option := ApplicationCommandBoolOption.new(option_name)
	options.append(option)
	return option

func add_user_option(option_name: String) -> ApplicationCommandUserOption:
	var option := ApplicationCommandUserOption.new(option_name)
	options.append(option)
	return option

func add_channel_option(option_name: String) -> ApplicationCommandChannelOption:
	var option := ApplicationCommandChannelOption.new(option_name)
	options.append(option)
	return option

func add_role_option(option_name: String) -> ApplicationCommandRoleOption:
	var option := ApplicationCommandRoleOption.new(option_name)
	options.append(option)
	return option

func build() -> Dictionary:
	var data: Dictionary = super()
	var _options: Array = []
	for option in options:
		_options.append(option.build())
	data["options"] = _options
	data.erase("required")
	return data

func get_class() -> String:
	return "ApplicationCommandSubCommand"

#func __set(_value) -> void:
#	pass
