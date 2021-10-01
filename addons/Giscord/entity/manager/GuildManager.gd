class_name GuildManager extends BaseDiscordEntityManager.BaseGuildManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_guild(data: Dictionary) -> Guild:
	var guild: Guild = Guild.new(parse_guild_payload(data))
	guild.set_meta("container", get_manager().container)
	return guild

func construct_guild_member(data: Dictionary) -> Guild.Member:
	var user = get_manager().get_or_construct_user(data["user"])
	
	var arguments: Dictionary = {
		id = user.id,
		guild_id = data["guild_id"],
		nickname = GDUtil.dict_get_or_default(data, "nick", ""),
		roles_ids = Snowflake.snowflakes2integers(data["roles"]),
		join_date = GDUtil.iso_to_unix_timestamp(data["joined_at"]),
		premium_since = GDUtil.iso_to_unix_timestamp(GDUtil.dict_get_or_default(data, "premium_since", "")),
		deaf = data["deaf"],
		mute = data["mute"],
		pending = data.get("pending", false)
	}
	var member: Guild.Member = Guild.Member.new(arguments)
	member.set_meta("container", get_manager().container)
	
	return member

func construct_role(data: Dictionary) -> Guild.Role:
	var arguments: Dictionary = {
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"],
		color = Color(int(data["color"])),
		hoist = data["hoist"],
		position = data["position"],
		permissions = data["permissions"] as int,
		is_managed = data["managed"],
		mentionable = data["mentionable"],
		tags = null if not data.has("tags") else Guild.Role.Tags.new({
			bot_id = data.get("bot_id", 0) as int,
			integration_id = data.get("integration_id", 0) as int,
			premium_subscriber = data.get("premium_subscriber")
		})
			
	}
	var role: Guild.Role = Guild.Role.new(arguments)
	role.set_meta("container", get_manager().container)
	
	return role

func update_guild(guild: Guild, data: Dictionary) -> void:
	guild._update(parse_guild_payload(data))

func parse_guild_payload(data: Dictionary) -> Dictionary:
	var guild_id = data["id"] as int
	
	var channels_ids: Array = []
	
	var roles: Dictionary = {}
	var members: Dictionary = {}
	var emojis: Dictionary = {}
	
	for role_data in data.get("roles", []):
		role_data["guild_id"] = guild_id
		var role: Guild.Role = construct_role(role_data)
		roles[role.id] = role
	
	for member_data in data.get("members", []):
		member_data["guild_id"] = guild_id
		var member: Guild.Member = construct_guild_member(member_data)
		members[member.id] = member
	
	for emoji_data in data.get("emojis", []):
		var emoji: Guild.GuildEmoji = get_manager().get_or_construct_emoji(emoji_data)
		emojis[emoji.id] = emoji

	var channels_data: Array = data.get("channels", [])
	for channel_data in channels_data:
		channel_data["guild_id"] = guild_id
		var channel = get_manager().get_or_construct_channel(channel_data)
		if channel:
			channels_ids.append(channel.id)

	for presence_data in data.get("presences", []):
		var _presence: Presence = self.get_manager().get_or_construct_presence(presence_data)
	return {
		id = guild_id,
		name = data.get("name", ""),
		icon_hash = GDUtil.dict_get_or_default(data, "icon", ""),
		splash_hash = GDUtil.dict_get_or_default(data, "splash", ""),
		discovery_splash_hash = GDUtil.dict_get_or_default(data, "discovery_splash", ""),
		afk_timeout = data.get("afk_timeout", 0),
		widget_enabled = data.get("widget_enabled", false),
		verification_level = data.get("verification_level", Guild.VerificationLevel.LOW),
		default_message_notifications = data.get("default_message_notifications", Guild.MessageNotificationLevel.ALL_MESSAGES),
		explicit_content_filter = data.get("explicit_content_filter", Guild.ExplicitContentFilterLevel.DISABLED),
		features = _convert_features_strings(data.get("features", [])),
		mfa_level = data.get("mfa_level", Guild.MFALevel.NONE),
		owner_id = data.get("owner_id", 0) as int,
		application_id = GDUtil.dict_get_or_default(data, "application_id", 0) as int,
		vanity_url_code = GDUtil.dict_get_or_default(data, "vanity_url_code", ""),
		description = GDUtil.dict_get_or_default(data, "description", ""),
		banner_hash = GDUtil.dict_get_or_default(data, "banner", ""),
		premium_tier = data.get("premium_tier", Guild.PremiumTier.NONE),
		system_channel_flags = data.get("system_channel_flags", Guild.SystemChannelFlags.DEFAULT),
		preferred_locale =  GDUtil.dict_get_or_default(data, "preferred_locale", "en-US"),
		nsfw_level = data.get("nsfw_level", Guild.NSFWLevel.DEFAULT),
		
		large = data.get("large", false),
		unavailable = data.get("unavailable", false),
		member_count = data.get("member_count", 0),
		max_presences = GDUtil.dict_get_or_default(data, "max_presences", 0),
		max_members = GDUtil.dict_get_or_default(data, "max_members", 0),
		premium_subscription_count = GDUtil.dict_get_or_default(data, "premium_subscription_count", 0),
		max_video_channel_users = GDUtil.dict_get_or_default(data, "max_video_channel_users", 0),
		
		afk_channel_id = GDUtil.dict_get_or_default(data, "afk_channel_id", 0) as int,
		widget_channel_id = GDUtil.dict_get_or_default(data, "widget_channel_id", 0) as int,
		system_channel_id = GDUtil.dict_get_or_default(data, "system_channel_id", 0) as int,
		rules_channel_id = GDUtil.dict_get_or_default(data, "rules_channel_id", 0) as int,
		public_updates_channel_id = GDUtil.dict_get_or_default(data, "public_updates_channel_id", 0) as int,
		
		channels_ids = channels_ids,
		roles = roles,
		members = members,
		emojis = emojis,
	}

func get_class() -> String:
	return "GuildManager"

static func _convert_features_strings(strings: Array) -> PoolIntArray:
	var features: PoolIntArray = []
	for feature in strings:
		features.append(Guild.Features[feature])
	return features
