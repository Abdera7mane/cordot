class_name ApplicationCommandStringOption extends ApplicationCommandChoicesBuilder

func _init(option_name: String).(option_name) -> void:
	type = DiscordApplicationCommandOption.Option.STRING

func add_choice(name: String, value: String) -> ApplicationCommandStringOption:
	_add_choice({name = name, value = value})
	return self

func get_class() -> String:
	return "ApplicationCommandStringOption"
