# Action to edit a guild text channel.
class_name TextChannelEditAction extends TextChannelAction

var _channel_id: int setget __set

# Constructs a new `TextChannelEditAction` instance.
func _init(rest: DiscordRESTMediator, channel_id: int).(rest) -> void:
	_type = DiscordREST.CHANNEL
	_method = "edit_channel"

	_channel_id = channel_id

# Edits the channel settings.
#
# doc-qualifiers:coroutine
# doc-override-return:GuildTextChannel
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "TextChannelEditAction"

func _get_arguments() -> Array:
	return [_channel_id, _data, _reason]

func __set(_value) -> void:
	pass

