class_name ApplicationCommandOptionBuilder

var type: int           
var name: String        
var description: String 
var required: bool      

func _init(option_name: String) -> void:
	name = option_name

func with_description(option_description: String) -> ApplicationCommandOptionBuilder:
	description = option_description
	return self

func is_required(value: bool) -> ApplicationCommandOptionBuilder:
	required = value
	return self

func build() -> Dictionary:
	return {
		type = type,
		name = name,
		description = description,
		required = required
	}

func get_class() -> String:
	return "ApplicationCommandOptionBuilder"

func __set(_value) -> void:
	pass
