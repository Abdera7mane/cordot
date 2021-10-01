class_name MessageActionRow extends MessageComponent

var components: Array setget __set

func _init(child_components: Array) -> void:
	components = child_components

func get_class() -> String:
	return "MessageActionRow"

func __set(_value) -> void:
	.__set(_value)
