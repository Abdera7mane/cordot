class_name PermissionOverwrite extends DiscordEntity

enum Type {
	ROLE,
	MEMBER
}

var type: int
var allow: BitFlag
var deny: BitFlag

func _init(data: Dictionary):
	super(data["id"])
	type = data["type"]
	allow = BitFlag.new((Permissions as Script).get_script_constant_map()).put(data["allow"])
	deny = BitFlag.new((Permissions as Script).get_script_constant_map()).put(data["deny"])

#func __set(_value) -> void:
#	pass
