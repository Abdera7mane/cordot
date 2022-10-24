class_name DiscordAutocompleteInteraction extends DiscordInteraction

const _Options: Dictionary = DiscordApplicationCommandOption.Option

var data: DiscordApplicationCommandData setget __set

# doc-hide
func _init(_data: Dictionary).(_data) -> void:
	data = _data["data"]

# Autocompletes the command options.
func autocomplete() -> InteractionAutocompleteAction:
	return InteractionAutocompleteAction.new(get_rest(), self.id, token)

func get_focused_option() -> DiscordApplicationCommandData.DataOption:
	var option: DiscordApplicationCommandData.DataOption
	var options: Array = data.options
	var i: int = 0
	while i < options.size():
		var current: DiscordApplicationCommandData.DataOption
		current = options[i]
		if current.focused:
			option = current
		else:
			match current.type:
				_Options.SUB_COMMAND, _Options.SUB_COMMAND_GROUP:
					options = current.options
					i = 0
					break
		i += 1
	
	return option

# doc-hide
func get_class() -> String:
	return "DiscordAutocompleteInteraction"

func __set(_value) -> void:
	pass
