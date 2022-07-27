class_name MessageEmbedField

var name: String  
var value: String 
var inline: bool  

func _init(_name: String, _value: String, _inline: bool) -> void:
	name = _name
	value = _value
	inline = _inline

func __set(_value) -> void:
	pass
