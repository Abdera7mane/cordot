class_name GuildManager extends BaseDiscordEntityManager.BaseGuildManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_guild(data: Dictionary) -> Guild:
	var manager: BaseDiscordEntityManager = self.get_manager()
	
	var guild: Guild = Guild.new(parse_guild_payload(data))
	guild.set_meta("container", manager.container)
	guild.set_meta("rest", manager.rest_mediator)
	
	return guild

func construct_guild_member(data: Dictionary) -> Guild.Member:
	var manager: BaseDiscordEntityManager = self.get_manager()
	
	var member: Guild.Member = Guild.Member.new(parse_guild_member_payload(data))
	member.set_meta("container", manager.container)
	member.set_meta("rest", manager.rest_mediator)
	
	return member

func construct_role(data: Dictionary) -> Guild.Role:
	var manager: BaseDiscordEntityManager = self.get_manager()
	
	var role: Guild.Role = Guild.Role.new(parse_role_payload(data))
	role.set_meta("container", manager.container)
	role.set_meta("rest", manager.rest_mediator)
	
	return role

func update_guild(guild: Guild, data: Dictionary) -> void:
	guild._update(parse_guild_payload(data))

func update_guild_member(member: Guild.Member, data: Dictionary) -> void:
	member._update(parse_guild_member_payload(data))

func update_role(role: Guild.Role, data: Dictionary) -> void:
	role._update(parse_role_payload(data))

func parse_guild_payload(data: Dictionary) -> Dictionary:
	var guild_id = data["id"] as int
	
	var parsed_data: Dictionary = {
		id = guild_id,
		name = data.get("name", ""),
		icon_hash = Dictionaries.get_non_null(data, "icon", ""),
		splash_hash = Dictionaries.get_non_null(data, "splash", ""),
		discovery_splash_hash = Dictionaries.get_non_null(data, "discovery_splash", ""),
		afk_timeout = data.get("afk_timeout", 0),
		widget_enabled = data.get("widget_enabled", false),
		verification_level = data.get("verification_level", Guild.VerificationLevel.LOW),
		default_message_notifications = data.get("default_message_notifications", Guild.MessageNotificationLevel.ALL_MESSAGES),
		explicit_content_filter = data.get("explicit_content_filter", Guild.ExplicitContentFilterLevel.DISABLED),
		features = _convert_features_strings(data.get("features", [])),
		mfa_level = data.get("mfa_level", Guild.MFALevel.NONE),
		owner_id = data.get("owner_id", 0) as int,
		application_id = Dictionaries.get_non_null(data, "application_id", 0) as int,
		vanity_url_code = Dictionaries.get_non_null(data, "vanity_url_code", ""),
		description = Dictionaries.get_non_null(data, "description", ""),
		banner_hash = Dictionaries.get_non_null(data, "banner", ""),
		premium_tier = data.get("premium_tier", Guild.PremiumTier.NONE),
		system_channel_flags = data.get("system_channel_flags", 0),
		preferred_locale =  Dictionaries.get_non_null(data, "preferred_locale", "en-US"),
		nsfw_level = data.get("nsfw_level", Guild.NSFWLevel.DEFAULT),
		
		max_presences = Dictionaries.get_non_null(data, "max_presences", 0),
		max_members = Dictionaries.get_non_null(data, "max_members", 0),
		premium_subscription_count = Dictionaries.get_non_null(data, "premium_subscription_count", 0),
		max_video_channel_users = Dictionaries.get_non_null(data, "max_video_channel_users", 0),
		
		afk_channel_id = Dictionaries.get_non_null(data, "afk_channel_id", 0) as int,
		widget_channel_id = Dictionaries.get_non_null(data, "widget_channel_id", 0) as int,
		system_channel_id = Dictionaries.get_non_null(data, "system_channel_id", 0) as int,
		rules_channel_id = Dictionaries.get_non_null(data, "rules_channel_id", 0) as int,
		public_updates_channel_id = Dictionaries.get_non_null(data, "public_updates_channel_id", 0) as int,
	}
	
	if data.has("roles"):
		var roles: Dictionary = {}
		for role_data in data["roles"]:
			role_data["guild_id"] = guild_id
			var role: Guild.Role = construct_role(role_data)
			roles[role.id] = role
		parsed_data["roles"] = roles
	
	if data.has("members"):
		var members: Dictionary = {}
		for member_data in data.get("members", []):
			member_data["guild_id"] = guild_id
			var member: Guild.Member = construct_guild_member(member_data)
			members[member.id] = member
		parsed_data["members"] = members
	
	if data.has("channels"):
		var channels_ids: Array = []
		for channel_data in data["channels"]:
			channel_data["guild_id"] = guild_id
			var channel = get_manager().get_or_construct_channel(channel_data)
			if channel:
				channels_ids.append(channel.id)
		parsed_data["channels_ids"] = channels_ids
	
	if data.has("emojis"):
		var emojis: Dictionary = {}
		for emoji_data in data["emojis"]:
			emoji_data["guild_id"] = guild_id
			var emoji: Guild.GuildEmoji = get_manager().get_or_construct_emoji(emoji_data)
			emojis[emoji.id] = emoji
		parsed_data["emojis"] = emojis
	
	for presence_data in data.get("presences", []):
		var _presence: Presence = self.get_manager().get_or_construct_presence(presence_data)
	
	if data.has("large"):
		parsed_data["is_large"] = data["large"]
	if data.has("unavailable"):
		parsed_data["unavailable"] = data["unavailable"]
	if data.has("member_count"):
		parsed_data["member_count"] = data["member_count"]
	
	return parsed_data

func parse_guild_member_payload(data: Dictionary) -> Dictionary:
	var user: User = get_manager().get_or_construct_user(data["user"])
	var parsed_data: Dictionary = {
		id = user.id,
		guild_id = data["guild_id"],
		nickname = Dictionaries.get_non_null(data, "nick", ""),
		avatar_hash = Dictionaries.get_non_null(data, "avatar", ""),
		roles_ids = Snowflake.snowflakes2integers(data["roles"]),
		join_date = Time.iso_to_unix(data["joined_at"]),
		premium_since = Time.iso_to_unix(Dictionaries.get_non_null(data, "premium_since", "")),
		deaf = data["deaf"],
		mute = data["mute"],
	}
	
	if data.has("pending"):
		parsed_data["pending"] = data["pending"]
	
	return parsed_data

func parse_role_payload(data: Dictionary) -> Dictionary:
	return {
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
			premium_subscriber = data.has("premium_subscriber")
		})
	}

func get_class() -> String:
	return "GuildManager"

static func _convert_features_strings(strings: Array) -> PoolIntArray:
	var features: PoolIntArray = []
	for feature in strings:
		features.append(Guild.Features[feature])
	return features
