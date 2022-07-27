class_name ApplicationCommandBoolOption extends ApplicationCommandOptionBuilder

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.BOOLEAN

func get_class() -> String:
	return "ApplicationCommandBoolOption"

func __set(_value) -> void:
	pass
