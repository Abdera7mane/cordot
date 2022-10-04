# A a non-interactive container for other type of message components.
class_name MessageActionRow extends MessageComponent

# List of `MessageInteractiveComponent`s.
var components: Array setget __set

# doc-hide
func _init(child_components: Array) -> void:
	type = Type.ACTION_ROW
	components = child_components

# Gets a component by `custom_id`.
func get_component(custom_id: String) -> MessageInteractiveComponent:
	var component: MessageInteractiveComponent
	for _component in components:
		if not component.custom_id.empty() and component.custom_id == custom_id:
			component = _component
			break
	return component

# doc-hide
func get_class() -> String:
	return "MessageActionRow"

func __set(_value) -> void:
	pass
