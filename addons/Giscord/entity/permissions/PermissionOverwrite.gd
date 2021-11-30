class_name PermissionOverwrite extends DiscordEntity

enum Type {
	ROLE,
	MEMBER
}

var type: int      setget __set
var allow: BitFlag setget __set
var deny: BitFlag  setget __set

func _init(data: Dictionary).(data["id"]):
	type = data["type"]
	allow = BitFlag.new(Permissions.get_script_constant_map()).put(data["allow"])
	deny = BitFlag.new(Permissions.get_script_constant_map()).put(data["deny"])

func __set(_value) -> void:
	pass
