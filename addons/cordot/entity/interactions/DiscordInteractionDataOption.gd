class_name DiscordInteractionDataOption

var name: String   
var type: int

# Variant
var value          
var options: Array 
var focused: bool  

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
