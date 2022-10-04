# Helper class to build message action rows.
class_name MessageActionRowBuilder extends MessageComponentBuilder

# Maximum number of component an action row can hold.
const MAX_COMPONENTS: int = 5

# Constructs a new `MessageActionRowBuilder` instance.
func _init().("", MessageComponent.Type.ACTION_ROW) -> void:	
	_data["components"] = []

# Appends a `component` to the action row.
# Type of `component` must not be an other action row.
func add_component(component: MessageComponentBuilder) -> MessageComponentBuilder:
	var components: Array = _data["components"]
	if component.get_script() == get_script():
		push_error("Action row can not contain an other action row")
	elif components.size() < MAX_COMPONENTS:
		components.append(component)
	else:
		push_error("Action row can only contain up to %d components" % MAX_COMPONENTS)
	return self

# doc-hide
func build() -> Dictionary:
	var components: Array = []
	for component in _data["components"]:
		components.append(component.build())
	var data: Dictionary = .build()
	data["components"] = components
	return data

# doc-hide
func get_class() -> String:
	return "MessageActionRowBuilder"
