class_name ApplicationCommandSubCommandGroup extends ApplicationCommandOptionBuilder

var options: Array setget __set

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.SUB_COMMAND_GROUP

func add_option(option: ApplicationCommandOptionBuilder) -> ApplicationCommandSubCommandGroup:
	options.append(option)
	return self

func add_subcommand(group_name: String) -> ApplicationCommandSubCommand:
	var option := ApplicationCommandSubCommand.new(group_name)
	options.append(option)
	return option

func build() -> Dictionary:
	var data: Dictionary = .build()
	var _options: Array = []
	for option in options:
		_options.append(option.build())
	data["options"] = _options
	return data

func get_class() -> String:
	return "ApplicationCommandSubCommandGroup"

func __set(_value) -> void:
	pass
