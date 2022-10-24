# Helper class to build user options for a slash command.
class_name ApplicationCommandUserOption extends ApplicationCommandOptionBuilder

# Constructs new command user option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.USER

# doc-hide
func get_class() -> String:
	return "ApplicationCommandUserOption"

func __set(_value) -> void:
	pass
