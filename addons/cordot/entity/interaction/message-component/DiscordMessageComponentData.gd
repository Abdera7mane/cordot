# Represents a message component interaction event data.
class_name DiscordMessageComponentData extends DiscordInteractionData

# Id of the component that fired this interaction.
var custom_id: String   setget __set

# Type of the component.
var component_type: int setget __set

# If `component_type` is `MessageComponent.Type.SELECT_MENU`
# this contains a list of `MessageSelectOption` objects.
var values: Array       setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	custom_id = data["custom_id"]
	component_type = data["component_type"]
	values = data.get("values", [])

# doc-hide
func get_class() -> String:
	return "DiscordMessageComponentData"

func __set(_value) -> void:
	pass
