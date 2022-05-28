class_name DiscordInteractionManager extends BaseDiscordInteractionManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_interaction(data: Dictionary) -> DiscordInteraction:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var interaction: DiscordInteraction = DiscordInteraction.new(parse_interaction_payload(data))
	interaction.set_meta("container", manager.container)
	interaction.set_meta("rest", manager.rest_mediator)
	
	return interaction

func construct_interaction_data(data: Dictionary) -> DiscordInteractionData:
	return DiscordInteractionData.new(parse_interaction_data_payload(data))

func construct_interaction_data_option(data: Dictionary) -> DiscordInteractionDataOption:
	return DiscordInteractionDataOption.new(parse_interaction_data_option_payload(data))

func construct_interaction_resolved_data(data: Dictionary) -> DiscordInteractionResolvedData:
	return DiscordInteractionResolvedData .new(parse_interaction_resolved_data_payload(data))

func parse_interaction_payload(data: Dictionary) -> Dictionary:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var interaction_data: DiscordInteractionData = null
	var user: User = null
	var member: Guild.Member = null
	var message: Message = null
	var guild_id: int = data.get("guild_id", 0) as int
	if data.has("data"):
		data["data"]["guild_id"] = guild_id
		interaction_data = construct_interaction_data(data["data"])
	if data.has("user"):
		user = manager.get_or_construct_user(data["user"])
	if data.has("member"):
		member = _get_guild_member_uncached(guild_id, data["member"])
	if data.has("message"):
		message = manager.get_or_construct_message(data["message"])
	return {
		id = data["id"] as int,
		application_id = data["application_id"] as int,
		type = data["type"],
		data = interaction_data,
		guild_id = guild_id,
		channel_id = data.get("channel_id", 0) as int,
		member = member,
		user_id = user.id if user else 0,
		token = data["token"],
		version = data["version"],
		message_id = message.id if message else 0,
		locale = data.get("locale", ""),
		guild_locale = data.get("guild_locale", "")
	}

func parse_interaction_data_payload(data: Dictionary) -> Dictionary:
	var guild_id: int = data.get("guild_id", 0)
	
	var resolved: DiscordInteractionResolvedData = null
	var options: Array = []
	var values: Array = []
	var components: Array = []
	
	if data.has("resolved"):
		var resolved_data: Dictionary = data["resolved"]
		resolved_data["guild_id"] = guild_id
		resolved = construct_interaction_resolved_data(resolved_data)
	
	if data.has("options"):
		for option_data in data["options"]:
			options.append(construct_interaction_data_option(option_data))
	if data.has("values"):
		pass
	if data.has("components"):
		pass
	return {
		command_id = data["id"] as int,
		name = data["name"],
		type = data["type"],
		resolved = resolved,
		options = options,
		custom_id = data.get("custom_id", ""),
		component_type = data.get("component_type", 0),
		values = values,
		target_id = data.get("target_id", 0),
		components = components,
	}

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
	
	var guild_id: int = data.get("guild_id", 0)
	
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
			var member: Guild.Member = _get_guild_member_uncached(guild_id, member_data)
			members[member.id] = member
			users[member.id] = member.user
			
	if data.has("users") and users.size() == 0:
		# TODO avoid caching newly constructed User objects
		var users_data: Dictionary = data["users"]
		for user_id in users_data.keys():
			var user_data: Dictionary = users_data[user_id]
			user_data["id"] = user_id
			var user: User = manager.get_or_construct_user(user_data)
			users[user.id] = user
	
	if data.has("roles"):
		# TODO get roles from cache
		var roles_data: Dictionary = data["roles"]
		for role_id in roles_data.keys():
			var role_data: Dictionary = roles_data[role_id]
			role_data["role_id"] = role_id
			role_data["guild_id"] = guild_id
			var role: Guild.Role = get_manager().guild_manager.construct_role(role_data)
			roles[role.id] = role
	
	if data.has("channels"):
		var channels_data: Dictionary = data["channels"]
		for channel_id in channels_data.keys():
			var channel_data: Dictionary = channels_data[channel_id]
			channel_data["id"] = channel_id
			var channel: PartialChannel = manager.channel_manager.construct_partial_channel(channel_data)
			channels[channel.id] = channel
	
	if data.has("messages"):
		# TODO avoid caching newly constructed Message objects
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

func _get_guild_member_uncached(guild_id: int, member_data: Dictionary) -> Guild.Member:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var member_id: int = member_data["user"]["id"] as int
	var guild: Guild = manager.get_guild(guild_id)
	var member: Guild.Member = guild._members.get(member_id)
	if not member:
		member = manager.guild_manager.construct_guild_member(member_data)
		member.set_meta("partial", true)
	return member
