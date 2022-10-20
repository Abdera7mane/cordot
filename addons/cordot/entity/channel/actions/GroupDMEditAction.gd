# Channel action to edit a group DM channel data.
class_name GroupDMEditAction extends DiscordRESTAction

# Maximum length of a channel name
const MAX_NAME_LENGTH: int = 100

var _guild_id: int    setget __set
var _data: Dictionary setget __set

func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.CHANNEL
	_method = "edit_channel"
	
	_guild_id = guild_id

# Modifies the channel settings.
#
# doc-qualifiers:coroutine
# doc-override-return:GroupDMChannel
func submit():
	return _submit()

# Sets the channel's name.
func set_name(name: String) -> GroupDMEditAction:
	name = name.strip_edges()
	if name.length() <= MAX_NAME_LENGTH:
		_data["name"] = name
	else:
		push_error("Channel names are limited to %d characters" % MAX_NAME_LENGTH)
	return self

# Sets the channel's icon.
func set_icon(image: Image) -> GroupDMEditAction:
	_data["icon"] = image
	return self

# doc-hide
func get_class() -> String:
	return "GroupDMEditAction"

func _get_arguments() -> Array:
	var data: Dictionary = _data.duplicate()
	var icon: Image = data.get("icon")
	if icon:
		data["icon"] = Marshalls.raw_to_base64(icon.get_data())
	return [_guild_id, data]

func __set(_value) -> void:
	pass

