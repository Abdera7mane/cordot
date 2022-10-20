# Action to create voice channels in a guild.
class_name VoiceChannelEditAction extends VoiceChannelAction

var _channel_id: int setget __set

# Constructs a new `VoiceChannelCreateAction` instance.
func _init(rest: DiscordRESTMediator, channel_id: int).(rest) -> void:
	_type = DiscordREST.CHANNEL
	_method = "edit_channel"

	_channel_id = channel_id

# Edits the voice channel.
#
# doc-qualifiers:coroutine
# doc-override-return:BaseGuildVoiceChannel
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "VoiceChannelCreateAction"

func __set(_value) -> void:
	pass

