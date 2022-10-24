# A command executed from a user context menu.
class_name DiscordMessageCommand extends DiscordApplicationCommandInteraction

# doc-hide
func _init(data: Dictionary).(data) -> void:
	pass

# Gets the targeted message in this command.
func get_target() -> Message:
	return data.resolved.messages[data.target_id]

# doc-hide
func get_class() -> String:
	return "DiscordMessageCommand"

