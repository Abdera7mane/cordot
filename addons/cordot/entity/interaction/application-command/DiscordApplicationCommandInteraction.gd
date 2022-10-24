# Abstract class for command based interaction.
# Such as `DiscordSlashCommand`s, `DiscordUserCommand`s
# and `DiscordMessageCommand`s.
class_name DiscordApplicationCommandInteraction extends DiscordRepliableInteraction

# Interaction data assossciated with the event.
var data: DiscordApplicationCommandData

# doc-hide
func _init(_data: Dictionary).(_data) -> void:
	data = _data["data"]

# Gets the name of the executed command.
func get_command() -> String:
	return data.name

# Shows a modal popup.
func show_modal(custom_id: String, title: String) -> InteractionModalAction:
	if replied:
		push_error("Already replied to interaction")
		return null

	var action := InteractionModalAction.new(get_rest(), self.id, token)\
			.set_custom_id(custom_id)\
			.set_title(title)
	# warning-ignore:return_value_discarded
	action.connect("completed", self, "_on_modal_shown", [], CONNECT_ONESHOT)

	return action

func _on_modal_shown(success: bool) -> void:
	replied = success

# doc-hide
func get_class() -> String:
	return "DiscordApplicationCommandInteraction"

func __set(_value) -> void:
	pass
