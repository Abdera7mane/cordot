# Helper class to build mentionable options (users and roles) for a slash command.
class_name ApplicationCommandMentionableOption extends ApplicationCommandOptionBuilder

# Constructs a new mentionable option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.MENTIONABLE

# doc-hide
func get_class() -> String:
	return "ApplicationCommandMentionableOption"

func __set(_value) -> void:
	pass
