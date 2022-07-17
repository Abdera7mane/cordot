class_name DiscordApplicationManager extends BaseDiscordApplicationManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_application(data: Dictionary) -> DiscordApplication:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var application: DiscordApplication = DiscordApplication.new(parse_application_payload(data))
	application.set_meta("container", manager.container)
	application.set_meta("rest", manager.rest_mediator)
	
	return application

func construct_application_command(data: Dictionary) -> DiscordApplicationCommand:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var command := DiscordApplicationCommand.new(parse_application_command_payload(data))
	command.set_meta("container", manager.container)
	command.set_meta("rest", manager.rest_mediator)
	
	return command

func construct_application_command_option(data: Dictionary) -> DiscordApplicationCommandOption:
	return DiscordApplicationCommandOption.new(parse_application_command_option_payload(data))

func construct_application_command_option_choice(data: Dictionary) -> DiscordApplicationCommandOptionChoice:
	return DiscordApplicationCommandOptionChoice.new(data["name"], data["value"])

func construct_team(data: Dictionary) -> DiscordTeam:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var team: DiscordTeam = DiscordTeam.new(parse_team_payload(data))
	team.set_meta("container", manager.container)
	team.set_meta("rest", manager.rest_mediator)
	
	return team

func construct_team_member(data: Dictionary) -> DiscordTeam.TeamMember:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var member := DiscordTeam.TeamMember.new(parse_team_member_payload(data))
	member.set_meta("container", manager.container)
	member.set_meta("rest", manager.rest_mediator)
	
	return member

func parse_application_payload(data: Dictionary) -> Dictionary:
	var owner: User = null
	var team: DiscordTeam = null
	if data.has("owner"):
		owner = get_manager().get_or_construct_user(data["owner"])
	if Dictionaries.has_non_null(data, "team"):
		team = construct_team(data["team"])
	return {
		id = data["id"] as int,
		name = data.get("name", ""),
		description = data.get("description", ""),
		icon_hash = Dictionaries.get_non_null(data, "icon", ""),
		rpc_origins = data.get("rpc_origins", []),
		is_bot_public = data.get("bot_public", false),
		bot_require_code_grant = data.get("bot_require_code_grant", false),
		tos_url = data.get("tos_url", ""),
		privacy_policy_url = data.get("privacy_policy_url", ""),
		owner_id = owner.id if owner else 0,
		summary = data.get("summary", ""),
		verify_key = data.get("verify_key", ""),
		team = team,
		guild_id = data.get("guild_id", 0) as int,
		primary_sku_id = data.get("primary_sku_id", 0) as int,
		slug = data.get("slug", ""),
		cover_image_hash = data.get("cover_image_hash", ""),
		flags = data.get("flags", 0)
	}

func parse_application_command_payload(data: Dictionary) -> Dictionary:
	return {
		id = data["id"] as int,
		type = data.get("type", DiscordApplicationCommand.Type.CHAT_INPUT),
		application_id = data["application_id"] as int,
		guild_id = data.get("guild_id", 0) as int,
		name = data["name"],
		description = data["description"],
		options = data.get("options", []),
		default_permission = data.get("default_permission", true),
		version = data["version"] as int
	}

func parse_team_payload(data: Dictionary) -> Dictionary:
	var members: Dictionary = {}
	for member_data in data["members"]:
		var member: DiscordTeam.TeamMember = construct_team_member(member_data)
		members[member.id] = member
	return {
		id = data["id"] as int,
		icon_hash = data.get("icon_hash", ""),
		members = members,
		name = data["name"],
		owner_id = data["owner_id"],
	}

func parse_team_member_payload(data: Dictionary) -> Dictionary:
	return {
		id = data["id"] as int,
		membership_state = data["membership_state"],
		permissions = data["permissions"],
		team_id = data["team_id"],
		user_id = data["user_id"]
	}

func parse_application_command_option_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
		type = data["type"],
		name = data["name"],
		description = data["description"],
		required = data.get("required", false),
		autocomplete = data.get("autocomplete", false),
		channel_types = data.get("channel_types", []),
		max_value = data.get("max_value", NAN),
		min_value = data.get("min_value", NAN)
	}
	
	if data.has("choices"):
		var choices: Array = []
		for choice_data in data["choices"]:
			choices.append(construct_application_command_option_choice(choice_data))
		parsed_data["choices"] = choices
	
	if data.has("options"):
		var options: Array = []
		for option_data in data["options"]:
			options.append(construct_application_command_option(option_data))
		parsed_data["options"] = options
	
	return parsed_data

func get_class() -> String:
	return "DiscordApplicationManager"
