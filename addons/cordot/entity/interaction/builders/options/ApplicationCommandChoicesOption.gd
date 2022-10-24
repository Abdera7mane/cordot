# Abstract builder for application command option choices.
class_name ApplicationCommandChoicesBuilder extends ApplicationCommandOptionBuilder

# List of choices stored in `Dictionary` containing `name`, `value`
# and `name_localizations` as keys.
var choices: Array     setget __set

# Whether autocomplete is enabled on this option.
var autocomplete: bool setget __set

# doc-hide
func _init(option_name: String).(option_name) -> void:
	pass

# Whether to enable autocomplete on this option. Can not be `true` if a list of
# choices were added.
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

# doc-hide
func build() -> Dictionary:
	var data: Dictionary = .build()
	if choices.size() > 0:
		data["choices"] = choices
	else:
		data["autocomplete"] = autocomplete
	return data

# doc-hide
func get_class() -> String:
	return "ApplicationCommandChoicesBuilder"

func __set(_value) -> void:
	pass
