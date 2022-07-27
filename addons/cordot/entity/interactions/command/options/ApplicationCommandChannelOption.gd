class_name ApplicationCommandChannelOption extends ApplicationCommandOptionBuilder

var channel_types: PackedInt32Array

func _init(option_name: String) -> void:
	type = DiscordApplicationCommandOption.Option.CHANNEL

func filter(types: PackedInt32Array) -> ApplicationCommandChannelOption:
	channel_types = types
	return self

func build() -> Dictionary:
	var data: Dictionary = super()
	if channel_types.size() > 0:
		data["channel_types"] = channel_types
	return data

func get_class() -> String:
	return "ApplicationCommandChannelOption"

func __set(_value) -> void:
	pass
