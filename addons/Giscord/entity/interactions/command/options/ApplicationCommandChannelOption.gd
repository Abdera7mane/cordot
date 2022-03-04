class_name ApplicationCommandChannelOption extends ApplicationCommandOptionBuilder

var channel_types: PoolIntArray setget __set

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.CHANNEL

func filter(types: PoolIntArray) -> ApplicationCommandChannelOption:
	channel_types = types
	return self

func build() -> Dictionary:
	var data: Dictionary = .build()
	if channel_types.size() > 0:
		data["channel_types"] = channel_types
	return data

func get_class() -> String:
	return "ApplicationCommandChannelOption"

func __set(_value) -> void:
	pass
