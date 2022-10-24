# Represents a modal submit interaction event data.
class_name DiscordModalSubmitData extends DiscordInteractionData

# Id of the modal that fired the event.
var custom_id: String setget __set

# List of `MessageComponent`s that the user submitted.
var components: Array setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	custom_id = data["custom_id"]
	components = data["components"]

# doc-hide
func get_class() -> String:
	return "DiscordModalSubmitData"

func __set(_value) -> void:
	pass

