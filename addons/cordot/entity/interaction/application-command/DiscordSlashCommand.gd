# A chat input based commad interaction, supports multiple options.
class_name DiscordSlashCommand extends DiscordApplicationCommandInteraction

const _Options: Dictionary = DiscordApplicationCommandOption.Option

# doc-hide
func _init(data: Dictionary).(data) -> void:
	pass

# Gets an option by `name`, returns `default` if not found.
# Set `expect_type` to a `DiscordApplicationCommandOption.Option`
# value to restric the return type.
func get_option(name: String, default = null, expect_type: int = 0): # Variant
	var options: Array = data.options
	var i: int = 0
	while i < options.size():
		var option: DiscordApplicationCommandData.DataOption
		option = options[i]
		match option.type:
			_Options.SUB_COMMAND, _Options.SUB_COMMAND_GROUP:
				options = option.options
				i = 0
				continue
		if option.name == name:
			var type: int = option.type
			if expect_type > 0 and type != expect_type:
				push_error("'%s' slash command '%s' option type is %s, epxected %s" % [
					get_command(),
					name,
					_get_option_type_name(type),
					_get_option_type_name(expect_type),
				])
				return null
			else:
				var value = option.value
				match type:
					_Options.USER:
						value = data.resolved.users.get(value, default)
					_Options.CHANNEL:
						value = data.resolved.channels.get(value, default)
					_Options.ROLE:
						value = data.resolved.roles.get(value, default)
					_Options.MENTIONABLE:
						if data.resolved.users.has(value):
							value = data.resolved.users[value]
						elif data.resolved.roles.has(value):
							value = data.resolved.roles[value]
						else:
							value = default
					_Options.ATTACHMENT:
						value = data.resolved.attachments.get(value, default)
				return value
		i += 1
	return default

# Gets a string option by `name`.
func get_string_option(name: String, default: String = "") -> String:
	var value = get_option(name, default, _Options.STRING)
	return value as String if value else ""

# Gets a integer option by `name`.
func get_integer_option(name: String, default: int = 0) -> int:
	var value = get_option(name, default, _Options.INTEGER)
	return value as int if value else 0

# Gets a number option by `name`.
func get_number_option(name: String, default: float = 0.0) -> float:
	var value = get_option(name, default, _Options.INTEGER)
	return value as float if value else 0.0

# Gets a boolean option by `name`.
func get_boolean_option(name: String, default: bool = false) -> bool:
	var value = get_option(name, default, _Options.BOOLEAN)
	return value as bool if value else false

# Gets a user option by `name`.
func get_user_option(name: String, default: User = null) -> User:
	return get_option(name, default, _Options.USER)

# Gets a channel option by `name`.
func get_channel_option(name: String, default: Channel = null) -> Channel:
	return get_option(name, default, _Options.CHANNEL)

# Gets a role option by `name`.
func get_role_option(name: String, default: Guild.Role = null) -> Guild.Role:
	return get_option(name, default, _Options.ROLE)

# Gets a mentionable entity (`User` or `Guild.Role`) option by `name`.
func get_mentionable_option(name: String, default: MentionableEntity = null) -> MentionableEntity:
	return get_option(name, default, _Options.MENTIONABLE)

# Gets an attachement option by `name`.
func get_attachment_option(name: String, default: MessageAttachment = null) -> MessageAttachment:
	return get_option(name, default, _Options.ATTACHMENT)

# Gets the number of options inputed by the user.
func get_options_count() -> int:
	return data.options.size()

# Checks if option by `name` exists.
func has_option(name: String) -> bool:
	var exists: bool = false
	for option in data.options:
		if option["name"] == name:
			exists = true
			break
	return exists

# doc-hide
func get_class() -> String:
	return "DiscordSlashCommand"

static func _get_option_type_name(type: int) -> String:
	var index: int = _Options.values().find(type)
	if index == -1:
		return "UKNOWN"
	return _Options.keys()[index]
