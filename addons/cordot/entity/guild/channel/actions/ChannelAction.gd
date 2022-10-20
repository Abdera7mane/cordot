# Abstract channel action.
class_name ChannelAction extends DiscordRESTAction

# Maximum channel name length.
const MAX_NAME_LENGTH: int = 100

var _data: Dictionary setget __set
var _reason: String   setget __set

# doc-hide
func _init(rest: DiscordRESTMediator).(rest) -> void:
	pass

# Sets the channel name.t
func set_name(name: String) -> ChannelAction:
	name = name.strip_edges()
	if name.empty():
		push_error("Channel name can not be empty")
	elif name.length() > MAX_NAME_LENGTH:
		push_error("Channel name length is limited to %d characters" % MAX_NAME_LENGTH)
	else:
		_data["name"] = name
	return self

# Sets the sorting postion of the channel.
func set_position(position: int) -> ChannelAction:
	_data["position"] = position
	return self

# Sets the channel's permission overites.
func set_permission_overwrites(overwrites: Array) -> ChannelAction:
	_data["permission_overwrites"] = overwrites
	return self

# Sets the reason for executing the action.
func reason(why: String) -> ChannelAction:
	_reason = why
	return self

func __set(_value) -> void:
	pass
 
