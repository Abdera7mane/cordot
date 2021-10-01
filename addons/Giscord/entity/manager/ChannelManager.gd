class_name ChannelManager extends BaseDiscordEntityManager.BaseChannelManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_channel(data: Dictionary) -> Channel:
	var channel: Channel = null
	
	match data["type"] as int:
		Channel.Type.GUILD_TEXT:
			channel = self.construct_guild_text_channel(data)
		Channel.Type.DM:
			channel = self.construct_dm_channel(data)
		Channel.Type.GUILD_VOICE:
			channel = self.construct_guild_voice_channel(data)
		Channel.Type.GROUP_DM:
			# It is impossible to receive this type on bot accounts
			# It only exist if Discord ever allow bots in dm group chat
			channel = self.construct_group_dm_channel(data)
		Channel.Type.GUILD_CATEGORY:
			channel = self.construct_guild_category_channel(data)
		Channel.Type.GUILD_NEWS:
			channel = self.construct_guild_news_channel(data)
		Channel.Type.GUILD_STORE:
			channel = self.construct_guild_store_channel(data)
		Channel.Type.GUILD_NEWS_THREAD,\
		Channel.Type.GUILD_PRIVATE_THREAD,\
		Channel.Type.GUILD_PUBLIC_THREAD:
			channel = self.construct_thread_channel(data)
		Channel.Type.GUILD_STAGE_VOICE:
			channel = self.construct_stage_channel(data)
		_:
			push_warning("Can not construct channel of type %d. Library outdated ?" % data["type"])
			
	if channel:
		channel.set_meta("container", self.get_manager().container)
	
	return channel

func construct_guild_text_channel(data: Dictionary) -> Guild.GuildTextChannel:
	return Guild.GuildTextChannel.new({
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"] as int,
		topic = GDUtil.dict_get_or_default(data, "topic", ""),
		position = data["position"],
		rate_limit_per_user = data["rate_limit_per_user"],
#		nsfw = data["nsfw"],  V9
		parent_id = GDUtil.dict_get_or_default(data, "parent_id", 0) as int,
		last_message_id = GDUtil.dict_get_or_default(data, "last_message_id", 0) as int,
#		default_auto_archive_duration = data["default_auto_archive_duration"] V9
	})

func construct_dm_channel(data: Dictionary) -> DMChannel:
	var users_ids: Array = []
	for recipient_data in data["recipients"]:
		var user: User = self.get_manager().get_or_construct_user(recipient_data)
		users_ids.append(user.id)
	
	return DMChannel.new({
		last_message_id = GDUtil.dict_get_or_default(data, "last_message_id", 0) as int,
		recipients_ids = users_ids
	})

func construct_guild_voice_channel(data: Dictionary) -> Guild.GuildVoiceChannel:
	var arguments: Dictionary = {
		id = data["id"] as int,
		guild_id = data["guild_id"] as int,
		name = data["name"],
		position = data["position"],
#		permission_overwirtes = data["permission_overites"],
		bitrate = data["bitrate"],
		user_limit = data["user_limit"],
		parent_id = GDUtil.dict_get_or_default(data, "parent_id", 0) as int,
		rtc_region = null
	}
	return Guild.GuildVoiceChannel.new(arguments)

# warning-ignore:unused_argument
func construct_group_dm_channel(data: Dictionary) -> GroupDMChannel:
	return null

func construct_guild_category_channel(data: Dictionary) -> Guild.ChannelCategory:
	var arguments: Dictionary = {
		id = data["id"] as int,
		guild_id = data["guild_id"] as int,
		name = data["name"],
		position = data["position"],
		permission_overwrites = data["permission_overwrites"]
	}
	return Guild.ChannelCategory.new(arguments)

func construct_guild_news_channel(data: Dictionary) -> Guild.GuildNewsChannel:
	return Guild.GuildNewsChannel.new({
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"] as int,
		topic = GDUtil.dict_get_or_default(data, "topic", ""),
		position = data["position"],
		rate_limit_per_user = data["rate_limit_per_user"],
#		nsfw = data["nsfw"],  V9
		parent_id = GDUtil.dict_get_or_default(data, "parent_id", 0) as int,
		last_message_id = GDUtil.dict_get_or_default(data, "last_message_id", 0) as int,
#		default_auto_archive_duration = data["default_auto_archive_duration"] V9
	})

# warning-ignore:unused_argument
func construct_guild_store_channel(data: Dictionary) -> Guild.GuildStoreChannel:
	return null

func construct_thread_channel(data: Dictionary) -> Guild.ThreadChannel:
	return null

func construct_stage_channel(data: Dictionary) -> Guild.StageChannel:
	return null

func get_class() -> String:
	return "ChannelManager"
