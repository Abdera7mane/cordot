class_name BaseDiscordApplicationManager

func construct_application(_data: Dictionary) -> DiscordApplication:
	return null

func construct_application_command(_data: Dictionary) -> DiscordApplicationCommand:
	return null

func construct_application_command_option(_data: Dictionary) -> DiscordApplicationCommandOption:
	return null

func construct_application_command_option_choice(_data: Dictionary) -> DiscordApplicationCommandOptionChoice:
	return null

func construct_team(_data: Dictionary) -> DiscordTeam:
	return null

func construct_team_member(_data: Dictionary) -> DiscordTeam.TeamMember:
	return null

func get_class() -> String:
	return "BaseDiscordApplicationManager"
