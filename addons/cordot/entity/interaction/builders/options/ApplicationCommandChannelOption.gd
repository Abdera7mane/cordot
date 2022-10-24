# Helper class to build channel options for a slash command.
class_name ApplicationCommandChannelOption extends ApplicationCommandOptionBuilder

# List of channel types to filter out.
var channel_types: PoolIntArray setget __set

# Constructs a new channel option builder.
func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.CHANNEL

# Provides a list of `Channel.Type`s to filter out the user's input.
func filter(types: PoolIntArray) -> ApplicationCommandChannelOption:
	channel_types = types
	return self

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	if channel_types.size() > 0:
		data["channel_types"] = channel_types
	return data

# doc-hide
func get_class() -> String:
	return "ApplicationCommandChannelOption"

func __set(_value) -> void:
	pass
