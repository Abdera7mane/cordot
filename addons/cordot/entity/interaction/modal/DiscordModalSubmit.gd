# An interaction event fired by a user after submitting a modal pop.
class_name DiscordModalSubmit extends DiscordRepliableInteraction

# Interaction data assossciated with the event.
var data: DiscordModalSubmitData setget __set

# doc-hide
func _init(_data: Dictionary).(_data) -> void:
	data = _data["data"]

# Gets a component from the modal data by `custom_id`.
func get_component(custom_id: String) -> MessageInteractiveComponent:
	for component in data.components:
		var child: MessageInteractiveComponent = component.components[0]
		if child.custom_id == custom_id:
			return child
	return null

# doc-hide
func get_class() -> String:
	return "DiscordModalSubmit"

func __set(_value) -> void:
	pass
