class_name MessageManager extends BaseMessageManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	self.entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_message(data: Dictionary) ->  Message:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var parsed_data: Dictionary = parse_message_data(data)
	
	var message: Message
	if data.has("guild_id"):
		message = GuildMessage.new(parsed_data)
	else:
		message = Message.new(parsed_data)
	
	message.set_meta("container", manager.container)
	message.set_meta("rest", manager.rest_mediator)
	
	return message

func construct_embed(data: Dictionary) -> MessageEmbed:
	var arguments: Dictionary = {
		title = data.get("title", ""),
		type = string_to_embed_type(data.get("type", "")),
		description = data.get("description", ""),
		url = data.get("url", ""),
		timestamp = TimeUtil.iso_to_unix(data.get("timestamp", "")),
		color = Colors.from_rgb24(int(data.get("color", 0))),
		footer = construct_embed_footer(data["footer"]) if data.has("footer") else null,
		image = construct_embed_image(data["image"]) if data.has("image") else null,
		thumbnail = construct_embed_thumbnail(data["thumbnail"]) if data.has("thumbnail") else null,
		video = construct_embed_video(data["video"]) if data.has("video") else null,
		provider = construct_embed_provider(data["provider"]) if data.has("provider") else null,
		author = construct_embed_author(data["author"]) if data.has("author") else null,
	}
	if data.has("fields"):
		var fields: Array = []
		for field_data in data["fields"]:
			fields.append(construct_embed_field(field_data))
		arguments["fields"] = fields
		
	return MessageEmbed.new(arguments)

func construct_embed_footer(data: Dictionary) -> MessageEmbedFooter:
	return MessageEmbedFooter.new(
		data["text"],
		data.get("icon_url", ""),
		data.get("proxy_icon_url", "")
	)

func construct_embed_image(data: Dictionary) -> MessageEmbedImage:
	return MessageEmbedImage.new(
		data.get("url", ""),
		data.get("proxy_url", ""),
		Vector2(data.get("height", 0), data.get("width", 0))
	)

func construct_embed_thumbnail(data: Dictionary) -> MessageEmbedThumbnail:
	return MessageEmbedThumbnail.new(
		data.get("url", ""),
		data.get("proxy_url", ""),
		Vector2(data.get("height", 0), data.get("width", 0))
	)

func construct_embed_video(data: Dictionary) -> MessageEmbedVideo:
	return MessageEmbedVideo.new(
		data.get("url", ""),
		data.get("proxy_url", ""),
		Vector2(data.get("height", 0), data.get("width", 0))
	)

func construct_embed_provider(data: Dictionary) -> MessageEmbedProvider:
	return MessageEmbedProvider.new(
		data.get("name", ""),
		data.get("url", "")
	)

func construct_embed_author(data: Dictionary) -> MessageEmbedAuthor:
	return MessageEmbedAuthor.new(
		data["name"],
		data.get("url", ""),
		data.get("icon_url", ""),
		data.get("proxy_icon_url", "")
	)

func construct_embed_field(data: Dictionary) -> MessageEmbedField:
	return MessageEmbedField.new(
		data["name"],
		data["value"],
		data.get("inline", "")
	)

func construct_message_attachment(data: Dictionary) -> MessageAttachment:
	var attachment: MessageAttachment = MessageAttachment.new({
		id = data["id"] as int,
		filename = data["filename"],
		description = data.get("description", ""),
		content_type = data.get("content_type", ""),
		size = data["size"],
		url = data["url"],
		proxy_url = data["proxy_url"],
		height = data.get("height", 0),
		width = data.get("width", 0),
		ephemeral = data.get("ephemeral", false)
	})
	
	var manager: BaseDiscordEntityManager = get_manager()
	attachment.set_meta("container", manager.container)
	attachment.set_meta("rest", manager.rest_mediator)
	
	return attachment

func construct_message_reference(data: Dictionary) -> MessageReference:
	return MessageReference.new({
		message_id = data.get("message_id", 0) as int,
		channel_id = data.get("channel_id", 0) as int,
		guild_id = data.get("guild_id", 0) as int,
	})

func construct_channel_mention(data: Dictionary) -> ChannelMention:
	return ChannelMention.new(
		data["id"] as int,
		data["guild_id"] as int,
		data["type"],
		data["name"]
	)

func construct_reaction(data: Dictionary) -> MessageReaction:
	return MessageReaction.new(
		data["count"],
		data["me"],
		get_manager().get_or_construct_emoji(data["emoji"])
	)

func construct_action_row(data: Dictionary) -> MessageActionRow:
	var components: Array = []
	for component_data in data["components"]:
		components.append(construct_message_component(component_data))
	return MessageActionRow.new(components)

func construct_button(data: Dictionary) -> MessageButton:
	var emoji: Emoji = null
	if data.has("emoji"):
		emoji = get_manager().get_or_construct_emoji(data["emoji"])
	var parsed_data: Dictionary = data.duplicate()
	parsed_data["emoji"] = emoji
	return MessageButton.new(parsed_data)

func construct_select_menu(data: Dictionary) -> MessageSelectMenu:
	var options: Array = []
	for option_data in data["options"]:
		options.append(construct_select_option(option_data))
	var parsed_data: Dictionary = data.duplicate()
	parsed_data["options"] = options
	return MessageSelectMenu.new(data)

func construct_select_option(data: Dictionary) -> MessageSelectOption:
	var emoji: Emoji = null
	if data.has("emoji"):
		emoji = get_manager().get_or_construct_emoji(data["emoji"])
	var parsed_data: Dictionary = data.duplicate()
	parsed_data["emoji"] = emoji
	return MessageSelectOption.new(parsed_data)

func construct_text_input(data: Dictionary) -> MessageTextInput:
	return MessageTextInput.new(data)

func update_message(message: Message, data: Dictionary) -> void:
	message._update(parse_message_data(data))

func parse_message_data(data: Dictionary) -> Dictionary:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var parsed_data: Dictionary = {
		id = data["id"] as int,
		channel_id = data["channel_id"] as int,
		nonce = str(data.get("nonce", ""))
	}
	
	if data.has("author"):
		var author: User = manager.get_or_construct_user(data["author"])
		parsed_data["author_id"] = author.id
	
	if data.has("guild_id"):
		parsed_data["guild_id"] = data["guild_id"] as int
	
	if data.has("type"):
		parsed_data["type"] = data["type"]
	
	if data.has("content"):
		parsed_data["content"] = data["content"]
	
	if data.has("timestamp"):
		parsed_data["timestamp"] = TimeUtil.iso_to_unix(data["timestamp"])
	
	if Dictionaries.has_non_null(data, "edited_timestamp"):
		parsed_data["type"] = TimeUtil.iso_to_unix(data["edited_timestamp"])
	
	if data.has("tts"):
		parsed_data["tts"] = data["tts"]
	
	if data.has("pinned"):
		parsed_data["pinned"] = data["pinned"]
	
	if data.has("mention_everyone"):
		parsed_data["mention_everyone"] = data["mention_everyone"]
	
	if data.has("mentions"):
		var mentions: Array = []
		for mention_data in data["mentions"]:
			if data.has("guild_id"):
				mention_data["member"]["user"] = mention_data.duplicate(true)
				mention_data["member"]["guild_id"] = data["guild_id"] as int
				var member: Guild.Member = manager.get_or_construct_guild_member(mention_data["member"])
				mentions.append(member)
			else:
				var user: User = manager.get_or_construct_user(mention_data, false)
				mentions.append(user)
		parsed_data["mentions"]  = mentions
	
	if data.has("attachments"):
		var attachments: Array = []
		for attachment_data in data["attachments"]:
			attachments.append(construct_message_attachment(attachment_data))
		parsed_data["attachments"] = attachments
	
	if data.has("embeds"):
		var embeds: Array = []
		for embed_data in data["embeds"]:
			embeds.append(construct_embed(embed_data))
		parsed_data["embeds"] = embeds
	
	if data.has("reactions"):
		var reactions: Array = []
		for reaction_data in data["reactions"]:
			reactions.append(construct_reaction(reaction_data))
		parsed_data["reactions"] = reactions
	
	if data.has("mention_channels"):
		var mention_channels: Array = []
		for mention_data in data["mention_channels"]:
			mention_channels.append(construct_message(mention_data))
		parsed_data["mention_channels"] = mention_channels
	
	if data.has("flags"):
		parsed_data["flags"] = data["flags"]
	
	if data.has("message_reference"):
		parsed_data["message_reference"] = construct_message_reference(data["message_reference"])
	if data.has("referenced_message"):
		if not Dictionaries.has_non_null(data, "referenced_message"):
			pass
		else:
			var reference_data: Dictionary = data["referenced_message"]
			var message: Message = manager.get_or_construct_message(reference_data, true)
			parsed_data["referenced_message_id"] = message.id
	
	if data.has("member"):
		var member_data: Dictionary = data["member"]
		member_data["user"] = data["author"]
		member_data["guild_id"] = parsed_data["guild_id"]
		var member: Guild.Member = manager.get_or_construct_guild_member(data["member"])
		parsed_data["member"] = member
	
	if data.has("components"):
		var components: Array = []
		for component_data in data["components"]:
			var component: MessageComponent = construct_message_component(component_data)
			components.append(component)
		data["components"] = components
	
	return parsed_data

func get_class() -> String:
	return "MessageManager"

static func string_to_embed_type(type: String) -> int:
	var default: int = MessageEmbed.Type.UNKNOWN
	return MessageEmbed.Type.get(type.to_upper(), default)
