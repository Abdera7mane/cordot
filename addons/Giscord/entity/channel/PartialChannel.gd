class_name PartialChannel extends DiscordEntity

var name: String setget __set
var type: int    setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	name = data["name"]
	type = data.get("type", Channel.Type.UNKNOWN)
	

func is_partial() -> bool:
	return true

func get_class() -> String:
	return "PartialChannel"

func __set(_value) -> void:
	pass
