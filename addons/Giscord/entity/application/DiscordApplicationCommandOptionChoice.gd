class_name DiscordApplicationCommandOptionChoice

var name: String setget __set

# Variant
var value        setget __set

func _init(_name: String, _value) -> void:
	name = _name
	value = _value

func get_class() -> String:
	return "DiscordApplicationCommandOptionChoice"

func __set(_value) -> void:
	pass
