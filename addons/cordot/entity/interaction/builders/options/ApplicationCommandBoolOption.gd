# Helper class to build boolean options for a slash command.
class_name ApplicationCommandBoolOption extends ApplicationCommandOptionBuilder

# Constructs a new boolean option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.BOOLEAN

# doc-hide
func get_class() -> String:
	return "ApplicationCommandBoolOption"

func __set(_value) -> void:
	pass
