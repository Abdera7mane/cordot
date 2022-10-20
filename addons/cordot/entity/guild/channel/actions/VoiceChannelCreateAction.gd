# Action to create voice channels in a guild.
class_name VoiceChannelCreateAction extends VoiceChannelAction

var _guild_id: int setget __set

# Constructs a new `VoiceChannelCreateAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "create_guild_channel"
	
	_guild_id = guild_id
	# warning-ignore:return_value_discarded
	as_stage(false)

# Creates the voice channel.
#
# doc-qualifiers:coroutine
# doc-override-return:BaseGuildVoiceChannel
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "VoiceChannelCreateAction"

func _get_arguments() -> Array:
	return [_guild_id, _data, _reason]

func __set(_value) -> void:
	pass

