class_name DiscordInteractionManager extends BaseDiscordInteractionManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_interaction(data: Dictionary) -> DiscordInteraction:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var interaction: DiscordInteraction
	var type: int = data["type"]
	
	match type:
		DiscordInteraction.Type.APPLICATION_COMMAND,\
		DiscordInteraction.Type.AUTOCOMPLETE:
			interaction = construct_application_command_interaction(data)
		
		DiscordInteraction.Type.MESSAGE_COMPONENT:
			interaction = construct_message_component_interaction(data)
		
		DiscordInteraction.Type.MODAL_SUBMIT:
			interaction = construct_modal_submit_interaction(data)
	
	interaction.set_meta("container", manager.container)
	interaction.set_meta("rest", manager.rest_mediator)
	
	return interaction

func construct_application_command_interaction(data: Dictionary) -> DiscordApplicationCommandInteraction:
	var interaction: DiscordApplicationCommandInteraction
	var type: int = data["data"]["type"]
	match type:
		DiscordApplicationCommand.Type.CHAT_INPUT:
			interaction = construct_slash_command(data)
		DiscordApplicationCommand.Type.USER:
			interaction = construct_user_command(data)
		DiscordApplicationCommand.Type.MESSAGE:
			interaction = construct_message_command(data)
	return interaction

func construct_slash_command(data: Dictionary) -> DiscordSlashCommand:
	return DiscordSlashCommand.new(
		parse_interaction_with_data_payload(data)
	)

func construct_user_command(data: Dictionary) -> DiscordUserCommand:
	return DiscordUserCommand.new(
		parse_interaction_with_data_payload(data)
	)

func construct_message_command(data: Dictionary) -> DiscordMessageCommand:
	return DiscordMessageCommand.new(
		parse_interaction_with_data_payload(data)
	)

func construct_message_component_interaction(data: Dictionary) -> DiscordMessageComponentInteraction:
	var parsed_data: Dictionary = parse_interaction_with_data_payload(data)
	parsed_data["message"] = get_manager().get_or_construct_message(data["message"])
	return DiscordMessageComponentInteraction.new(parsed_data)

func construct_modal_submit_interaction(data: Dictionary) -> DiscordModalSubmit:
	return DiscordModalSubmit.new(
		parse_interaction_with_data_payload(data)
	)

func construct_interaction_data(data: Dictionary, type: int) -> DiscordInteractionData:
	var interaction_data: DiscordInteractionData
	
	match type:
		DiscordInteraction.Type.APPLICATION_COMMAND,\
		DiscordInteraction.Type.AUTOCOMPLETE:
			interaction_data = construct_application_command_data(data)
		
		DiscordInteraction.Type.MESSAGE_COMPONENT:
			interaction_data = construct_message_component_data(data)
		
		DiscordInteraction.Type.MODAL_SUBMIT:
			interaction_data = construct_modal_submit_data(data)
	
	return interaction_data

func construct_application_command_data(data: Dictionary) -> DiscordApplicationCommandData:
	var resolved: DiscordApplicationCommandResolvedData = null
	var options: Array = []
	
	if data.has("resolved"):
		resolved = construct_interaction_resolved_data(data["resolved"])
	for option_data in data.get("options", []):
		options.append(construct_interaction_data_option(option_data))
	
	return DiscordApplicationCommandData.new({
		command_id = data["id"] as int,
		name = data["name"],
		type = data["type"],
		resolved = resolved,
		options = options,
		target_id = data.get("target_id", 0) as int,
		guild_id = data.get("guild_id", 0) as int
	})

func construct_message_component_data(data: Dictionary) -> DiscordMessageComponentData:
	var message_manager: BaseMessageManager = get_manager().message_manager
	var values: Array = []
	for select_option_data in data.get("values", []):
		values.append(message_manager.construct_select_option(select_option_data))
	var parsed_data: Dictionary = data.duplicate()
	parsed_data["values"] = values
	return DiscordMessageComponentData.new(parsed_data)

func construct_modal_submit_data(data: Dictionary) -> DiscordModalSubmitData:
	var message_manager: BaseMessageManager = get_manager().message_manager
	var components: Array = []
	for component_data in data["components"]:
		components.append(message_manager.construct_message_component(component_data))
	var parsed_data: Dictionary = data.duplicate()
	parsed_data["components"] = components
	return DiscordModalSubmitData.new(parsed_data)

func construct_interaction_data_option(data: Dictionary) -> DiscordApplicationCommandData.DataOption:
	return DiscordApplicationCommandData.DataOption.new(
		parse_interaction_data_option_payload(data)
	)

func construct_interaction_resolved_data(data: Dictionary) -> DiscordApplicationCommandResolvedData:
	return DiscordApplicationCommandResolvedData.new(parse_interaction_resolved_data_payload(data))

func parse_interaction_payload(data: Dictionary) -> Dictionary:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var user: User = null
	var member: Guild.Member = null
	var guild_id: int = data.get("guild_id", 0) as int
	
	if data.has("user"):
		user = manager.get_or_construct_user(data["user"])
	if data.has("member"):
		var member_data: Dictionary = data["member"]
		member_data["guild_id"] = guild_id
		member = manager.get_or_construct_guild_member(member_data)
	
	var parsed_data: Dictionary = {
		id = data["id"] as int,
		application_id = data["application_id"] as int,
		type = data["type"],
		guild_id = guild_id,
		channel_id = data.get("channel_id", 0) as int,
		member = member,
		user = user,
		user_id = user.id if user else 0,
		token = data["token"],
		version = data["version"],
		locale = data.get("locale", ""),
		guild_locale = data.get("guild_locale", "")
	}
	
	if data.has("app_permission"):
		parsed_data["app_permission"] = data["app_permission"] as int
	
	return parsed_data

func parse_interaction_with_data_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
		data = construct_interaction_data(data["data"], data["type"])
	}
	
	Dictionaries.merge(
		parsed_data,
		parse_interaction_payload(data)
	)
	
	return parsed_data

func parse_interaction_data_option_payload(data: Dictionary) -> Dictionary:
	var options: Array = []
	if data.has("options"):
		for option_data in data["options"]:
			options.append(construct_interaction_data_option(option_data))
	return {
		name = data["name"],
		type = data["type"],
		value = data.get("value"),
		options = options,
		focused = data.get("focused", false),
	}

func parse_interaction_resolved_data_payload(data: Dictionary) -> Dictionary:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var guild_id: int = data.get("guild_id", 0) as int
	
	var users: Dictionary = {}
	var members: Dictionary = {}
	var roles: Dictionary = {}
	var channels: Dictionary = {}
	var messages: Dictionary = {}
	var attachments: Dictionary = {}
	
	if data.has("members"):
		var members_data: Dictionary = data["members"]
		for member_id in members_data.keys():
			var member_data: Dictionary = members_data[member_id]
			member_data["user"] = data["users"][member_id]
			member_data["user"]["id"] = member_id
			member_data["guild_id"] = guild_id
			var member: Guild.Member = manager\
							.get_or_construct_guild_member(member_data)
			members[member.id] = member
			users[member.id] = member.user
			
	if data.has("users") and users.size() == 0:
		var users_data: Dictionary = data["users"]
		for user_id in users_data.keys():
			var user_data: Dictionary = users_data[user_id]
			user_data["id"] = user_id
			var user: User = manager.get_or_construct_user(user_data, false)
			users[user.id] = user
	
	if data.has("roles"):
		var roles_data: Dictionary = data["roles"]
		for role_id in roles_data.keys():
			var role_data: Dictionary = roles_data[role_id]
			role_data["role_id"] = role_id
			role_data["guild_id"] = guild_id
			
			var role: Guild.Role = null
			if manager.container.guilds.has(guild_id):
				role = manager.container.guilds[guild_id].get_role(role_id)
			if not role:
				role = manager.guild_manager.construct_role(role_data)
			
			roles[role.id] = role
	
	if data.has("channels"):
		var channels_data: Dictionary = data["channels"]
		for channel_id in channels_data.keys():
			var channel_data: Dictionary = channels_data[channel_id]
			channel_data["id"] = channel_id
			var channel: PartialChannel = manager.channel_manager\
							.construct_partial_channel(channel_data)
			channels[channel.id] = channel
	
	if data.has("messages"):
		var messages_data: Dictionary = data["messages"]
		for message_id in messages.keys():
			var message_data: Dictionary = messages_data[message_id]
			message_data["id"] = message_id
			var message: Message = manager.get_or_construct_message(message_data)
			messages[message.id] = message
		
	if data.has("attachments"):
		var attachments_data: Dictionary = data["attachments"]
		for attachment_id in attachments_data.keys():
			var attachment_data: Dictionary = attachments_data[attachment_id]
			attachment_data["id"] = attachment_id
			var attachment: MessageAttachment = manager.message_manager\
							.construct_message_attachment(attachment_data)
			attachments[attachment.id] = attachment
	
	return {
		users = users,
		members = members,
		roles = roles,
		channels = channels,
		messages = messages,
		attachments = attachments,
	}

func get_class() -> String:
	return "DiscordInteractionManager"
