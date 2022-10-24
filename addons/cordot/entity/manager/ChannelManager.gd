class_name ChannelManager extends BaseChannelManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	self.entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_channel(data: Dictionary) -> Channel:
	var channel: Channel = null
	
	var type: int = data["type"] as int
	match type:
		Channel.Type.GUILD_TEXT:
			channel = construct_guild_text_channel(data)
		Channel.Type.DM:
			channel = construct_dm_channel(data)
		Channel.Type.GUILD_VOICE:
			channel = construct_guild_voice_channel(data)
		Channel.Type.GROUP_DM:
			# It is impossible to receive this type on bot accounts
			channel = construct_group_dm_channel(data)
		Channel.Type.GUILD_CATEGORY:
			channel = construct_guild_category_channel(data)
		Channel.Type.GUILD_NEWS:
			channel = construct_guild_news_channel(data)
		Channel.Type.GUILD_STORE:
			channel = construct_guild_store_channel(data)
		Channel.Type.GUILD_NEWS_THREAD,\
		Channel.Type.GUILD_PRIVATE_THREAD,\
		Channel.Type.GUILD_PUBLIC_THREAD:
			channel = construct_thread_channel(data)
		Channel.Type.GUILD_STAGE_VOICE:
			channel = construct_stage_channel(data)
		_:
			push_warning("Can not construct channel of type %d. Library outdated ?" % type)
			
	if channel:
		var manager: BaseDiscordEntityManager = self.get_manager()
		channel.set_meta("container", manager.container)
		channel.set_meta("rest", manager.rest_mediator)
	
	return channel

func update_channel(channel: Channel, data: Dictionary) -> void:
	var type: int = data["type"] as int
	match type:
		Channel.Type.GUILD_TEXT:
			channel._update(parse_guild_text_channel_payload(data))
		Channel.Type.DM:
			channel._update(parse_dm_channel_payload(data))
		Channel.Type.GUILD_VOICE:
			channel._update(parse_guild_voice_channel_payload(data))
		Channel.Type.GROUP_DM:
			channel._update(parse_group_dm_channel_payload(data))
		Channel.Type.GUILD_CATEGORY:
			channel._update(parse_category_channel_payload(data))
		Channel.Type.GUILD_NEWS:
			channel._update(parse_guild_text_channel_payload(data))
		Channel.Type.GUILD_STORE:
			channel._update(parse_guild_channel_payload(data))
		Channel.Type.GUILD_NEWS_THREAD,\
		Channel.Type.GUILD_PRIVATE_THREAD,\
		Channel.Type.GUILD_PUBLIC_THREAD:
			channel._update(parse_thread_channel_payload(data))
		Channel.Type.GUILD_STAGE_VOICE:
			channel._update(parse_guild_voice_channel_payload(data))

func construct_guild_text_channel(data: Dictionary) -> Guild.GuildTextChannel:
	return Guild.GuildTextChannel.new(parse_guild_text_channel_payload(data))

func construct_dm_channel(data: Dictionary) -> DMChannel:
	return DMChannel.new(parse_dm_channel_payload(data))

func construct_guild_voice_channel(data: Dictionary) -> Guild.GuildVoiceChannel:
	var parsed_data: Dictionary = parse_guild_voice_channel_payload(data)
	parsed_data["text_channel"] = parse_text_channel_payload(data)
	parsed_data["text_channel"]["id"] = parsed_data["id"]
	return Guild.GuildVoiceChannel.new(parsed_data)

func construct_group_dm_channel(data: Dictionary) -> GroupDMChannel:
	return GroupDMChannel.new(parse_group_dm_channel_payload(data))

func construct_guild_category_channel(data: Dictionary) -> Guild.ChannelCategory:
	return Guild.ChannelCategory.new(parse_category_channel_payload(data))

func construct_guild_news_channel(data: Dictionary) -> Guild.GuildNewsChannel:
	return Guild.GuildNewsChannel.new(parse_guild_text_channel_payload(data))

func construct_guild_store_channel(data: Dictionary) -> Guild.GuildStoreChannel:
	return Guild.GuildStoreChannel.new(parse_guild_channel_payload(data))

func construct_thread_channel(data: Dictionary) -> Guild.ThreadChannel:
	return Guild.ThreadChannel.new(parse_thread_channel_payload(data))

func construct_thread_mdetadata(data: Dictionary) -> Guild.ThreadMetaData:
	return Guild.ThreadMetaData.new(parse_thread_metadata(data))

func construct_stage_channel(data: Dictionary) -> Guild.StageChannel:
	return Guild.StageChannel.new(parse_guild_voice_channel_payload(data))

func construct_partial_channel(data: Dictionary) -> PartialChannel:
	return PartialChannel.new({
		id = data["id"] as int,
		name = data["name"],
		type = data.get("type", Channel.Type.UNKNOWN)
	})

func construct_permission_overwrite(data: Dictionary) -> PermissionOverwrite:
	return PermissionOverwrite.new({
		id = data["id"] as int,
		type = data["type"],
		allow = data["allow"] as int,
		deny = data["deny"] as int
	})

func parse_text_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {}
	if Dictionaries.has_non_null(data, "last_pin_timestamp"):
		parsed_data["last_pin_timestamp"] = TimeUtil.iso_to_unix(data["last_pin_timestamp"])
	if Dictionaries.has_non_null(data, "last_message_id"):
		parsed_data["last_message_id"] = data["last_message_id"] as int
	return parsed_data

func parse_guild_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"] as int,
		position = data["position"],
		parent_id = Dictionaries.get_non_null(data, "parent_id", 0) as int,
	}
	if data.has("permission_overwrites"):
		var overwrites: Dictionary = {}
		for overwrite_data in data["permission_overwrites"]:
			var overwrite: PermissionOverwrite = construct_permission_overwrite(overwrite_data)
			overwrites[overwrite.id] = overwrite
		parsed_data["overwrites"] = overwrites
	return parsed_data

func parse_guild_text_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
			topic = Dictionaries.get_non_null(data, "topic", ""),
			rate_limit_per_user = data["rate_limit_per_user"],
			nsfw = data.get("nsfw", false),
			auto_archive_duration = data.get("default_auto_archive_duration", 0)
		}
	
	Dictionaries.merge(
		parsed_data,
		parse_guild_channel_payload(data)
	)
	Dictionaries.merge(
		parsed_data,
		parse_text_channel_payload(data)
	)
	
	return parsed_data

func parse_guild_voice_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
			bitrate = data["bitrate"],
			user_limit = data["user_limit"],
		}
	
	Dictionaries.merge(
		parsed_data,
		parse_guild_channel_payload(data)
	)
	
	return  parsed_data

func parse_category_channel_payload(data: Dictionary) -> Dictionary:
	return parse_guild_channel_payload(data)

func parse_dm_channel_payload(data: Dictionary) -> Dictionary:
	var users_ids: Array = []
	for recipient_data in data["recipients"]:
		var user: User = self.get_manager().get_or_construct_user(recipient_data)
		users_ids.append(user.id)
	
	var parsed_data: Dictionary = {
			id = data["id"] as int,
			users_ids = users_ids
		}
	
	Dictionaries.merge(
		parsed_data,
		parse_text_channel_payload(data)
	)
	
	return parsed_data

func parse_group_dm_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
			name = data["name"],
			icon_hash = Dictionaries.get_non_null(data, "icon", ""),
			owner_id = data["owner_id"] as int
		}
	
	Dictionaries.merge(
		parsed_data,
		parse_dm_channel_payload(data)
	)
	
	return parsed_data

func parse_thread_channel_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"] as int,
		parent_id = data["parent_id"] as int,
		owner_id = data["owner_id"] as int,
		rate_limit_per_user = data["rate_limit_per_user"],
		auto_archive_duration = data.get("auto_archive_duration", 0),
		type = data["type"]
	}
	if data.has("message_count"):
		parsed_data["message_count"] = data["message_count"]
	if data.has("member_count"):
		parsed_data["member_count"] = data["member_count"]
	if data.has("thread_metadata"):
		parsed_data["metadata"] = construct_thread_mdetadata(data["thread_metadata"])
	
	Dictionaries.merge(
		parsed_data,
		parse_text_channel_payload(data)
	)
	
	return parsed_data

func parse_thread_metadata(data: Dictionary) -> Dictionary:
	return {
		archived = data["archived"],
		auto_archive_duration = data["auto_archive_duration"],
		archive_timestamp = TimeUtil.iso_to_unix(data["archive_timestamp"]),
		locked = data["locked"],
		invitable = data.get("invitable", false),
		create_timestamp = TimeUtil.iso_to_unix(
			Dictionaries.get_non_null(data, "create_timestamp", "")
		)
	}

func get_class() -> String:
	return "ChannelManager"
