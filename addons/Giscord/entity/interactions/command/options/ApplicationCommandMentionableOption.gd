class_name ApplicationCommandMentionableOption extends ApplicationCommandOptionBuilder

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.MENTIONABLE

func get_class() -> String:
	return "ApplicationCommandMentionableOption"

func __set(_value) -> void:
	pass
