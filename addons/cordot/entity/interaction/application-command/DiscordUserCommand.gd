# A command executed from a user context menu.
class_name DiscordUserCommand extends DiscordApplicationCommandInteraction

# doc-hide
func _init(data: Dictionary).(data) -> void:
	pass

# Gets the targeted user in this command.
func get_target() -> User:
	return data.resolved.users[data.target_id]

# doc-hide
func get_class() -> String:
	return "DiscordUserCommand"

