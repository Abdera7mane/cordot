# Action to create a channel category in a guild.
class_name ChannelCategoryCreateAction extends ChannelAction

var _channel_id: int setget __set

# Constructs a new `ChannelCategoryCreateAction` instance.
func _init(rest: DiscordRESTMediator, channel_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "create_guild_channel"
	
	_channel_id = channel_id
	_data["type"] = Channel.Type.GUILD_CATEGORY

# Creates the category.
#
# doc-qualifiers:coroutine
# doc-override-return:ChannelCategory
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "ChannelCategoryCreateAction"

func _get_arguments() -> Array:
	return [_channel_id, _data, _reason]

func __set(_value) -> void:
	pass

