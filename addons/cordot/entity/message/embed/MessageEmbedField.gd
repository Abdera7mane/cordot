# Represents a field withing a message embed.
class_name MessageEmbedField

# Name of the field.
var name: String  setget __set

# Value of the field.
var value: String setget __set

# Whether or not this field should display inline.
var inline: bool  setget __set

# doc-hide
func _init(_name: String, _value: String, _inline: bool) -> void:
	name = _name
	value = _value
	inline = _inline

func __set(_value) -> void:
	pass
