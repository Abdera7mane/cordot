# Helper class to build role options for a slash command.
class_name ApplicationCommandRoleOption extends ApplicationCommandOptionBuilder

# Constructs a new role option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.ROLE

# doc-hide
func get_class() -> String:
	return "ApplicationCommandRoleOption"

func __set(_value) -> void:
	pass
