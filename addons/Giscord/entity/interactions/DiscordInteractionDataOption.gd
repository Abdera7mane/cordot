class_name DiscordInteractionDataOption

var name: String   setget __set
var type: int

# Variant
var value          setget __set
var options: Array setget __set
var focused: bool  setget __set

func _init(data: Dictionary) -> void:
	name = data["name"]
	type = data["type"]
	value = data.get("value")
	options = data.get("options", [])
	focused = data.get("focused", false)

func get_class() -> String:
	return "DiscordInteractionDataOption"

func __set(_value) -> void:
	pass
