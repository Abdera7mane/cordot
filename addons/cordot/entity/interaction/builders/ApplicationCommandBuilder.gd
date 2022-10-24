# Helper class to construct application commands data.
class_name ApplicationCommandBuilder

# Name application command.
var name: String        setget __set

# Description of application command.
var description: String setget __set

# If building a slash command (chat input command),
# this contains command options.
var options: Array      setget __set

# Type of application command.
var type: int           setget __set

# Constructs a builder for `command_name`.
func _init(command_name: String) -> void:
	name = command_name

# Adds an option to a slash command.
func add_option(option: ApplicationCommandOptionBuilder) -> ApplicationCommandBuilder:
	if options.size() > 0 and not options[-1].required and option.required:
		push_error("'required=true' command options must be added first")
	else:
		options.append(option)
	return self

# Adds a sub-command group.
func add_subcommand_group(group_name: String) -> ApplicationCommandSubCommandGroup:
	var option := subcommand_group_builder(group_name)
	options.append(option)
	return option

# Adds a subcommand.
func add_subcommand(subcommand: String) -> ApplicationCommandSubCommand:
	var option := subcommand_builder(subcommand)
	options.append(option)
	return option

# Adds a string option.
func add_string_option(option_name: String) -> ApplicationCommandStringOption:
	var option := string_option_builder(option_name)
	options.append(option)
	return option

# Adds an integer option.
func add_integer_option(option_name: String) -> ApplicationCommandIntegerOption:
	var option := integer_option_builder(option_name)
	options.append(option)
	return option

# Adds a bollean option.
func add_boolean_option(option_name: String) -> ApplicationCommandBoolOption:
	var option := boolean_option_builder(option_name)
	options.append(option)
	return option

# Adds a user option.
func add_user_option(option_name: String) -> ApplicationCommandUserOption:
	var option := user_option_builder(option_name)
	options.append(option)
	return option

# Adds channel option.
func add_channel_option(option_name: String) -> ApplicationCommandChannelOption:
	var option := channel_option_builder(option_name)
	options.append(option)
	return option

# Adds a role option.
func add_role_option(option_name: String) -> ApplicationCommandRoleOption:
	var option := role_option_builder(option_name)
	options.append(option)
	return option

# Adds a mentionable option.
func add_mentionable_option(option_name: String) -> ApplicationCommandMentionableOption:
	var option := mentionable_option_builder(option_name)
	options.append(option)
	return option

# Adds a number option.
func add_number_option(option_name: String) -> ApplicationCommandNumberOption:
	var option := number_option_builder(option_name)
	options.append(option)
	return option

# Adds an attachment option.
func add_attachment_option(option_name: String) -> ApplicationCommandAttachmentOption:
	var option := attachment_option_builder(option_name)
	options.append(option)
	return option

# Sets the command description.
func with_description(command_description: String) -> ApplicationCommandBuilder:
	description = command_description
	return self

# Sets command's type.
func of_type(command_type: int) -> ApplicationCommandBuilder:
	type = command_type
	return self
# Sets the command's type to slash command.
func as_chat_input() -> ApplicationCommandBuilder:
	return of_type(DiscordApplicationCommand.Type.CHAT_INPUT)

# Sets the command's type to user command.
func as_user_command() -> ApplicationCommandBuilder:
	return of_type(DiscordApplicationCommand.Type.USER)

# Sets the command's type to message command.
func as_message_command() -> ApplicationCommandBuilder:
	return of_type(DiscordApplicationCommand.Type.MESSAGE)

# Creates a new sub-comand group builder
func subcommand_group_builder(group_name: String) -> ApplicationCommandSubCommandGroup:
	return ApplicationCommandSubCommandGroup.new(group_name)

# Creates a new sub-command builder.
func subcommand_builder(subcommand: String) -> ApplicationCommandSubCommand:
	return ApplicationCommandSubCommand.new(subcommand)

# Creates a new string builder.
func string_option_builder(option_name: String) -> ApplicationCommandStringOption:
	return ApplicationCommandStringOption.new(option_name)

# Creates a new integer builder.
func integer_option_builder(option_name: String) -> ApplicationCommandIntegerOption:
	return ApplicationCommandIntegerOption.new(option_name)

# Creates a new boolean builder.
func boolean_option_builder(option_name: String) -> ApplicationCommandBoolOption:
	return ApplicationCommandBoolOption.new(option_name)

# Creates a new user builder.
func user_option_builder(option_name: String) -> ApplicationCommandUserOption:
	return ApplicationCommandUserOption.new(option_name)

# Creates a new channel builder.
func channel_option_builder(option_name: String) -> ApplicationCommandChannelOption:
	return ApplicationCommandChannelOption.new(option_name)

# Creates a new role builder.
func role_option_builder(option_name: String) -> ApplicationCommandRoleOption:
	return ApplicationCommandRoleOption.new(option_name)

# Creates a new mentuinable builder.
func mentionable_option_builder(option_name: String) -> ApplicationCommandMentionableOption:
	return ApplicationCommandMentionableOption.new(option_name)

# Creates a new number builder.
func number_option_builder(option_name: String) -> ApplicationCommandNumberOption:
	return ApplicationCommandNumberOption.new(option_name)

# Creates a new attachment builder.
func attachment_option_builder(option_name: String) -> ApplicationCommandAttachmentOption:
	return ApplicationCommandAttachmentOption.new(option_name)

# Builds the commands data.
func build() -> Dictionary:
	var _options: Array = []
	for option in options:
		_options.append(option.build())
	var data = {
		name = name,
		description = description,
		type = type
	}
	if _options:
		data["options"] = _options
	return data

# doc-hide
func get_class() -> String:
	return "ApplicationCommandBuilder"

func __set(_value) -> void:
	pass
