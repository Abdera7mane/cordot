class_name DiscordInteractionData

var command_id: int                          setget __set
var name: String                             setget __set
var type: int                                setget __set
var resolved: DiscordInteractionResolvedData setget __set
var options: Array                           setget __set
var custom_id: String                        setget __set
var component_type: int                      setget __set
var values: Array                            setget __set
var target_id: int                           setget __set
var components: Array                        setget __set

func _init(data: Dictionary) -> void:
	command_id = data["command_id"]
	name = data["name"]
	type = data["type"]
	resolved = data.get("resolved")
	options = data.get("options", [])
	custom_id = data.get("custom_id", "")
	component_type = data.get("component_type", 0)
	values = data.get("values", [])
	target_id = data.get("target_id", 0)
	components = data.get("components", [])

func get_class() -> String:
	return "DiscordInteractionData"

func __set(_value) -> void:
	pass
