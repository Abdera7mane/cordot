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
	return Guild.GuildVoiceChannel.new(parse_guild_voice_channel_payload(data))

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
		parsed_data["last_pin_timestamp"] = Time.iso_to_unix(data["last_pin_timestamp"])
	if Dictionaries.has_non_null(data, "last_message_id"):
		parsed_data["last_message_id"] = data["last_message_id"] as int
	return parsed_data

func parse_guild_channel_payload(data: Dictionary) -> Dictionary:
	var overwrites: Array = []
	for overwrite in data.get("permission_overwrites", []):
		overwrites.append(construct_permission_overwrite(overwrite))
	
	return {
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"] as int,
		position = data["position"],
		parent_id = Dictionaries.get_non_null(data, "parent_id", 0) as int,
		permission_overwrites = overwrites
	}

func parse_guild_text_channel_payload(data: Dictionary) -> Dictionary:
	return Dictionaries.merge(
		parse_guild_channel_payload(data),
		Dictionaries.merge(
		parse_text_channel_payload(data),
		{
			topic = Dictionaries.get_non_null(data, "topic", ""),
			rate_limit_per_user = data["rate_limit_per_user"],
#			nsfw = data["nsfw"],  V9
#			default_auto_archive_duration = data["default_auto_archive_duration"] V9
		})
	)

func parse_guild_voice_channel_payload(data: Dictionary) -> Dictionary:
	return Dictionaries.merge(
		parse_guild_channel_payload(data),
		{
			bitrate = data["bitrate"],
			user_limit = data["user_limit"],
			rtc_region = null
		}
	)

func parse_category_channel_payload(data: Dictionary) -> Dictionary:
	return parse_guild_channel_payload(data)

func parse_dm_channel_payload(data: Dictionary) -> Dictionary:
	var users_ids: Array = []
	for recipient_data in data["recipients"]:
		var user: User = self.get_manager().get_or_construct_user(recipient_data)
		users_ids.append(user.id)
	
	return Dictionaries.merge(
		parse_text_channel_payload(data),
		{
			id = data["id"] as int,
			users_ids = users_ids
		}
	)

func parse_group_dm_channel_payload(data: Dictionary) -> Dictionary:
	return Dictionaries.merge(
		parse_dm_channel_payload(data),
		{
			name = data["name"],
			icon_hash = Dictionaries.get_non_null(data, "icon", ""),
			owner_id = data["owner_id"] as int
		}
	)

func parse_thread_channel_payload(data: Dictionary) -> Dictionary:
	var metadata: Dictionary = data["thread_metadata"]
	return Dictionaries.merge(
		parse_text_channel_payload(data),
		{
			id = data["id"] as int,
			guild_id = data["guild_id"] as int,
			parent_id = data["parent_id"] as int,
			owner_id = data["owner_id"] as int,
			name = data["name"],
			type = data["type"],
			message_count = data["message_count"],
			member_count = data["member_count"],
			rate_limit_per_user = data["rate_limit_per_user"],
			archived = metadata[""],
			auto_archive_duration = metadata["auto_archive_duration"],
			archive_timestamp = Time.iso_to_unix(metadata["archive_timestamp"]),
			locked = metadata["locked"],
			invitable = metadata["invitable"]
		}
	)

func get_class() -> String:
	return "ChannelManager"
