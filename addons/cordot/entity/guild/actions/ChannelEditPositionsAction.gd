# Action to edit channel postions inside a guild.
class_name ChannelEditPositionsAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _data: Dictionary setget __set

# Constrcts a new `ChannelEditPostionsAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "edit_guild_channel_positions"

	_guild_id = guild_id

# Edits the channels positions.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func submit():
	return _submit()

# Includes a channel to edit its position.
func for_channel(id: int) -> ChannelPosition:
	var position: ChannelPosition = ChannelPosition.new(id)
	_data[id] = position
	return position

# doc-hide
func get_class() -> String:
	return "ChannelEditPositionsAction"

func _get_arguments() -> Array:
	var positions: Array = []
	for position in _data.values():
		positions.append(position.to_dict())
	return [_guild_id, positions]

func __set(_value) -> void:
	pass

# Represents a channel postion edit.
class ChannelPosition:
	var _data: Dictionary setget __set, to_dict

	# Construct a new channel postion.
	func _init(id: int) -> void:
		_data["id"] = str(id)

	# Sets the sorting position of the channel.
	func set_position(position: int) -> ChannelPosition:
		_data["position"] = position
		return self

	# Sets the parent channel id for the channel.
	# If `sync_permissions` is `true`, the permission overites will be synchronised
	# with the new parent.
	# Node
	func set_parent(id: int, sync_permissions: bool = false) -> ChannelPosition:
		_data["parent_id"] = str(id)
		_data["lock_permissions"] = sync_permissions
		return self

	# Removes the channel's parent channel.
	func remove_parent() -> ChannelPosition:
		_data["parent_id"] = null
		# warning-ignore:return_value_discarded
		_data.erase("lock_permissions")
		return self

	# doc-hide
	func get_class() -> String:
		return "ChannelEditPositionsAction.ChannelPosition"

	# Converts the position data to a `Dictionary`.
	func to_dict() -> Dictionary:
		return _data.duplicate()

	func __set(_value) -> void:
		pass

	
