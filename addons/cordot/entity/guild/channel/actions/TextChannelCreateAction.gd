# Action to create a text channel in a guild.
class_name TextChannelCreateAction extends TextChannelAction

var _guild_id: int setget __set

# Constructs a new `TextChannelCreateAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "create_guild_channel"
	
	_guild_id = guild_id
	# warning-ignore:return_value_discarded
	as_news(false)

# Creates the text channel.
#
# doc-qualifiers:coroutine
# doc-override-return:GuildTextChannel
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "TextChannelCreateAction"

func _get_arguments() -> Array:
	return [_guild_id, _data, _reason]

func __set(_value) -> void:
	pass

