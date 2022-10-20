# Action to edit a guild category channel.
class_name ChannelCategoryEditAction extends ChannelAction

var _channel_id: int setget __set

# Constructs a new `ChannelCategoryEditAction` instance.
func _init(rest: DiscordRESTMediator, channel_id: int).(rest) -> void:
	_type = DiscordREST.CHANNEL
	_method = "edit_channel"

	_channel_id = channel_id
	
# Edits the category.
#
# doc-qualifiers:coroutine
# doc-override-return:ChannelCategory
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "ChannelCategoryEditAction"

func _get_arguments() -> Array:
	return [_channel_id, _data, _reason]

func __set(_value) -> void:
	pass

