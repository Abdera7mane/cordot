class_name ApplicationCommandNumberOption extends ApplicationCommandChoicesBuilder

var min_value: float = NAN
var max_value: float = NAN

func _init(option_name: String) -> void:
	super(option_name)
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
	var data: Dictionary = super()
	if not is_nan(min_value):
		data["min_value"] = min_value
	if not is_nan(max_value):
		data["max_value"] = max_value
	return data

func get_class() -> String:
	return "ApplicationCommandNumberOption"

func __set(_value) -> void:
	pass
