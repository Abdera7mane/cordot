class_name ApplicationCommandUserOption extends ApplicationCommandOptionBuilder

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.USER

func get_class() -> String:
	return "ApplicationCommandUserOption"

func __set(_value) -> void:
	pass
