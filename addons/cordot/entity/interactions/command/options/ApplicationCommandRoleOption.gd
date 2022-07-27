class_name ApplicationCommandRoleOption extends ApplicationCommandOptionBuilder

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.ROLE

func get_class() -> String:
	return "ApplicationCommandRoleOption"

func __set(_value) -> void:
	pass
