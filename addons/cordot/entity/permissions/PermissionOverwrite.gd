# Holds permissions of a role or member on a channel-level.
class_name PermissionOverwrite extends DiscordEntity

# Overwrite target.
enum Type {
	ROLE,
	MEMBER
}

# Overwrite target type, can be either `Type.ROLE` or `Type.MEMBER`.
var type: int      setget __set

# Allowed permissions.
var allow: BitFlag setget __set

# Denied permissions.
var deny: BitFlag  setget __set

# doc-hide
func _init(data: Dictionary).(data["id"]):
	type = data["type"]
	allow = BitFlag.new(Permissions.get_script_constant_map()).put(data["allow"])
	deny = BitFlag.new(Permissions.get_script_constant_map()).put(data["deny"])

func __set(_value) -> void:
	pass
