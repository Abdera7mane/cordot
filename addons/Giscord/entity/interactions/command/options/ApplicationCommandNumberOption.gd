class_name ApplicationCommandNumberOption extends ApplicationCommandChoicesBuilder

var min_value: float = NAN setget __set
var max_value: float = NAN setget __set

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.NUMBER

func add_choice(name: String, value: float) -> ApplicationCommandNumberOption:
	_add_choice({name = name, value = value})
	return self

func set_min(value: float) -> ApplicationCommandNumberOption:
	min_value = value
	return self

func set_max(value: float) -> ApplicationCommandNumberOption:
	max_value = value
	return self

func build() -> Dictionary:
	var data: Dictionary = .build()
	if not is_nan(min_value):
		data["min_value"] = min_value
	if not is_nan(max_value):
		data["max_value"] = max_value
	return data

func get_class() -> String:
	return "ApplicationCommandNumberOption"

func __set(_value) -> void:
	pass
