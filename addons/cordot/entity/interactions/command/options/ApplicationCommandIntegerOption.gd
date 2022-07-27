class_name ApplicationCommandIntegerOption extends ApplicationCommandChoicesBuilder

var _enable_max: bool
var _enable_min: bool

var min_value: int
var max_value: int

func _init(option_name: String) -> void:
	super(option_name)
	type = DiscordApplicationCommandOption.Option.INTEGER

func add_choice(name: String, value: int) -> ApplicationCommandIntegerOption:
	_add_choice({name = name, value = value})
	return self

func set_min(value: int) -> ApplicationCommandIntegerOption:
	min_value = value
	_enable_min = true
	return self

func set_max(value: int) -> ApplicationCommandIntegerOption:
	max_value = value
	_enable_max = true
	return self

func build() -> Dictionary:
	var data: Dictionary = super()
	if _enable_min:
		data["min_value"] = min_value
	if _enable_max:
		data["max_value"] = max_value
	return data

func get_class() -> String:
	return "ApplicationCommandIntegerOption"

func __set(_value) -> void:
	pass
