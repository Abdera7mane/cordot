# Action to edit roles positions in a guild.
class_name RoleEditPositionsAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _data: Dictionary setget __set
var _reason: String   setget __set

# Constructs a new `RoleEditPositionsAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "edit_guild_role_positions"

	_guild_id = guild_id

# Includes a role to edit its position.
func for_role(id: int, position: int) -> RoleEditPositionsAction:
	_data[id] = {
		id = id,
		position = position
	}
	return self

# Sets the reason for editing the positions.
func reason(why: String) -> RoleEditPositionsAction:
	_reason = why
	return self

func _get_arguments() -> Array:
	return [_guild_id, _data.values(), _reason]

# doc-hide  
func get_class() -> String:
	return "RoleEditPositionsAction"

func __set(_value) -> void:
	pass

