class_name ApplicationCommandRoleOption extends ApplicationCommandOptionBuilder

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.ROLE

func get_class() -> String:
	return "ApplicationCommandRoleOption"

func __set(_value) -> void:
	pass
