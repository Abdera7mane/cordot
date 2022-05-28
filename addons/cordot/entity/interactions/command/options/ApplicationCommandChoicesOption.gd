class_name ApplicationCommandChoicesBuilder extends ApplicationCommandOptionBuilder

var choices: Array     setget __set
var autocomplete: bool setget __set

func _init(option_name: String).(option_name) -> void:
	pass

func set_autocomplete(value: bool) -> ApplicationCommandChoicesBuilder:
	if choices.size() > 0 and value:
		push_error("Can not enable autocomplete when choices are present")
	else:
		autocomplete = value
	return self

func _add_choice(choice: Dictionary) -> void:
	if choices.size() < 25:
		choices.append(choice)
		if autocomplete:
			autocomplete = false
			push_error("Disabled command autocomplete after added a choice")
	else:
		push_error("Application command choices are limited to a max of 25")

func build() -> Dictionary:
	var data: Dictionary = .build()
	if choices.size() > 0:
		data["choices"] = choices
	else:
		data["autocomplete"] = autocomplete
	return data

func get_class() -> String:
	return "ApplicationCommandChoicesBuilder"

func __set(_value) -> void:
	pass
