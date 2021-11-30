class_name MessageEmbedField

var name: String  setget __set
var value: String setget __set
var inline: bool  setget __set

func _init(_name: String, _value: String, _inline: bool) -> void:
	name = _name
	value = _value
	inline = _inline

func __set(_value) -> void:
	pass
