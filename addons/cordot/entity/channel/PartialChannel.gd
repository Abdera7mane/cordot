class_name PartialChannel extends DiscordEntity

var name: String
var type: int
var permissions: BitFlag

func _init(data: Dictionary) -> void:
	super(data["id"])
	permissions = BitFlag.new((Permissions as Script).get_script_constant_map())

	name = data["name"]
	type = data.get("type", Channel.Type.UNKNOWN)
	permissions = data.get("permissions", 0)

func is_partial() -> bool:
	return true

func get_class() -> String:
	return "PartialChannel"

#func __set(_value) -> void:
#	pass
