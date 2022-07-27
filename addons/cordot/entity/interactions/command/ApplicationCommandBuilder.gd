class_name ApplicationCommandBuilder

var name: String                    
var description: String             
var options: Array                  
var default_permission: bool = true 
var type: int = 1                   

func _init(command_name: String) -> void:
	name = command_name

func add_option(option: ApplicationCommandOptionBuilder) -> ApplicationCommandBuilder:
	if options.size() > 0 and not options[-1].required and option.required:
			push_error("'required=true' command options must be added first")
	else:
		options.append(option)
	return self

func add_subcommand_group(group_name: String) -> ApplicationCommandSubCommandGroup:
	var option := subcommand_group_builder(group_name)
	options.append(option)
	return option

func add_subcommand(subcommand: String) -> ApplicationCommandSubCommand:
	var option := subcommand_builder(subcommand)
	options.append(option)
	return option

func add_string_option(option_name: String) -> ApplicationCommandStringOption:
	var option := string_option_builder(option_name)
	options.append(option)
	return option

func add_integer_option(option_name: String) -> ApplicationCommandIntegerOption:
	var option := integer_option_builder(option_name)
	options.append(option)
	return option

func add_boolean_option(option_name: String) -> ApplicationCommandBoolOption:
	var option := boolean_option_builder(option_name)
	options.append(option)
	return option

func add_user_option(option_name: String) -> ApplicationCommandUserOption:
	var option := user_option_builder(option_name)
	options.append(option)
	return option

func add_channel_option(option_name: String) -> ApplicationCommandChannelOption:
	var option := channel_option_builder(option_name)
	options.append(option)
	return option

func add_role_option(option_name: String) -> ApplicationCommandRoleOption:
	var option := role_option_builder(option_name)
	options.append(option)
	return option

func add_mentionable_option(option_name: String) -> ApplicationCommandMentionableOption:
	var option := mentionable_option_builder(option_name)
	options.append(option)
	return option

func add_number_option(option_name: String) -> ApplicationCommandNumberOption:
	var option := number_option_builder(option_name)
	options.append(option)
	return option

func add_attachment_option(option_name: String) -> ApplicationCommandAttachmentOption:
	var option := attachment_option_builder(option_name)
	options.append(option)
	return option

func with_description(command_description: String) -> ApplicationCommandBuilder:
	description = command_description
	return self

func with_default_permission(value: bool) -> ApplicationCommandBuilder:
	default_permission = value
	return self

func of_type(command_type: int) -> ApplicationCommandBuilder:
	type = command_type
	return self

func subcommand_group_builder(group_name: String) -> ApplicationCommandSubCommandGroup:
	return ApplicationCommandSubCommandGroup.new(group_name)

func subcommand_builder(subcommand: String) -> ApplicationCommandSubCommand:
	return ApplicationCommandSubCommand.new(subcommand)

func string_option_builder(option_name: String) -> ApplicationCommandStringOption:
	return ApplicationCommandStringOption.new(option_name)

func integer_option_builder(option_name: String) -> ApplicationCommandIntegerOption:
	return ApplicationCommandIntegerOption.new(option_name)

func boolean_option_builder(option_name: String) -> ApplicationCommandBoolOption:
	return ApplicationCommandBoolOption.new(option_name)

func user_option_builder(option_name: String) -> ApplicationCommandUserOption:
	return ApplicationCommandUserOption.new(option_name)

func channel_option_builder(option_name: String) -> ApplicationCommandChannelOption:
	return ApplicationCommandChannelOption.new(option_name)

func role_option_builder(option_name: String) -> ApplicationCommandRoleOption:
	return ApplicationCommandRoleOption.new(option_name)

func mentionable_option_builder(option_name: String) -> ApplicationCommandMentionableOption:
	return ApplicationCommandMentionableOption.new(option_name)

func number_option_builder(option_name: String) -> ApplicationCommandNumberOption:
	return ApplicationCommandNumberOption.new(option_name)

func attachment_option_builder(option_name: String) -> ApplicationCommandAttachmentOption:
	return ApplicationCommandAttachmentOption.new(option_name)

func build() -> Dictionary:
	var _options: Array = []
	for option in options:
		_options.append(option.build())
	return {
		name = name,
		description = description,
		options = _options,
		default_permission = default_permission,
		type = type
	}

func get_class() -> String:
	return "ApplicationCommandBuilder"

func __set(_value) -> void:
	pass
