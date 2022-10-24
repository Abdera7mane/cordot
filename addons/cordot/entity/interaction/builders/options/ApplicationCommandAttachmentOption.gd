# Helper class to build attachment options for a slash command.
class_name ApplicationCommandAttachmentOption extends ApplicationCommandOptionBuilder

# Constructs a new attachment option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.ATTACHMENT

# doc-hide
func get_class() -> String:
	return "ApplicationCommandAttachmentOption"

func __set(_value) -> void:
	pass
