# Abstract command option builder.
class_name ApplicationCommandOptionBuilder

# Type of option.
var type: int           setget __set

# Name of option.
var name: String        setget __set

# Description of option.
var description: String setget __set

# Whether the option is reuired.
var required: bool      setget __set

# Constructs a new option builder.
func _init(option_name: String) -> void:
	name = option_name

# Sets the options description.
func with_description(option_description: String) -> ApplicationCommandOptionBuilder:
	description = option_description
	return self

# Whether the option should be required.
func is_required(value: bool) -> ApplicationCommandOptionBuilder:
	required = value
	return self

# doc-hide
func build() -> Dictionary:
	return {
		type = type,
		name = name,
		description = description,
		required = required
	}

# doc-hide
func get_class() -> String:
	return "ApplicationCommandOptionBuilder"

func __set(_value) -> void:
	pass
