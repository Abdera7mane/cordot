class_name ApplicationCommandAttachmentOption extends ApplicationCommandOptionBuilder

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.ATTACHMENT

func get_class() -> String:
	return "ApplicationCommandAttachmentOption"

func __set(_value) -> void:
	pass
