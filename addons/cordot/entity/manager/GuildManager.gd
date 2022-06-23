class_name GuildManager extends BaseGuildManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	self.entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

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

func construct_invite(data: Dictionary) -> Guild.Invite:
	var manager: BaseDiscordEntityManager = get_manager()
	var arguments: Dictionary = {
		code = data["code"],
		channel = manager.channel_manager.construct_partial_channel(data["channel"]),
		target_type = data.get("target_type", 0),
		presence_count = data.get("approximate_presence_count", 0),
		member_count = data.get("approximate_member_count", 0),
		expires_at = TimeUtil.iso_to_unix(Dictionaries.get_non_null(data, "expires_at", "")),
	}
	
	if data.has("guild"):
		var guild: Guild = manager.get_or_construct_guild((data["guild"]), false)
		arguments["guild"] = guild
		
	if data.has("inviter"):
		var inviter: User = manager.get_or_construct_user(data["inviter"], false)
		arguments["inviter"] = inviter
	
	if data.has("target_user"):
		var target_user: User = manager.get_or_construct_user(data["target_user"], false)
		arguments["target_user"] = target_user
	
	if data.has("target_application"):
		pass
	
	if data.has("stage_instance"):
		data["stage_instance"]["guild_id"] = data["guild"]["id"] as int
		arguments["stage_instance"] = construct_invite_stage_instance(data["stage_instance"])
	
	if data.has("guild_scheduled_event"):
		arguments["scheduled_event"] = construct_guild_scheduled_event(data["guild_scheduled_event"])
	
	return Guild.Invite.new(arguments)

func construct_invite_stage_instance(data: Dictionary) -> StageInstanceInvite:
	var members: Array = []
	for member_data in data["members"]:
		var member: Guild.Member = get_manager().get_or_construct_guild_member(member_data)
		members.append(member)
	return StageInstanceInvite.new({
			members = members,
			participant_count = data["participant_count"],
			speaker_count = data["speaker_count"],
			topic = data["topic"]
		})

func construct_guild_scheduled_event(data: Dictionary) -> Guild.GuildScheduledEvent:
	var manager: BaseDiscordEntityManager = get_manager()
	var arguments: Dictionary = {
		guild_id = data["guild_id"] as int,
		channel_id = data.get("channel_id", 0) as int,
		creator_id = data.get("creator_id", 0) as int,
		name = data["name"],
		description = data.get("description", ""),
		start_time = data.get("start_time", 0),
		end_time = data.get("end_time", 0),
		privacy_level = data["privacy_level"],
		status = data["status"],
		entity_id = data.get("entity_id", 0),
		entity_type = data["entity_type"],
	}
	if data.has("creator"):
		arguments["creator"] = manager.get_or_construct_user(data["creator"], false)
	if Dictionaries.has_non_null(data, "entity_metadata"):
		arguments["entity_metadata"] = construct_guild_event_metadata(data["entity_metadata"])
	
	var event: Guild.GuildScheduledEvent = Guild.GuildScheduledEvent.new(arguments)
	event.set_meta("container", manager.container)
	event.set_meta("rest", manager.rest_mediator)
	
	return event

func construct_guild_event_metadata(data: Dictionary) -> Guild.ScheduledEventMetadata:
	return Guild.ScheduledEventMetadata.new(data.get("location", ""))

func construct_voice_state(data: Dictionary) -> Guild.VoiceState:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var state: Guild.VoiceState = Guild.VoiceState.new(parse_voice_state_payload(data))
	state.set_meta("container", manager.container)
	state.set_meta("rest", manager.rest_mediator)
	
	return state

func update_guild(guild: Guild, data: Dictionary) -> void:
	guild._update(parse_guild_payload(data))

func update_guild_member(member: Guild.Member, data: Dictionary) -> void:
	member._update(parse_guild_member_payload(data))

func update_role(role: Guild.Role, data: Dictionary) -> void:
	role._update(parse_role_payload(data))

func update_voice_state(state: Guild.VoiceState, data: Dictionary) -> void:
	state._update(parse_voice_state_payload(data))

func parse_guild_payload(data: Dictionary) -> Dictionary:
	var manager: BaseDiscordEntityManager = get_manager()
	var guild_id = data["id"] as int
	var guild: Guild = manager.container.guilds.get(guild_id)
	
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
	
	if manager.cache_flags.GUILD_MEMBERS and data.has("members"):
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
			var channel = manager.get_or_construct_channel(channel_data)
			if channel:
				channels_ids.append(channel.id)
		parsed_data["channels_ids"] = channels_ids
	
	if data.has("emojis"):
		var emojis: Dictionary = {}
		for emoji_data in data["emojis"]:
			emoji_data["guild_id"] = guild_id
			var emoji: Guild.GuildEmoji = manager.get_or_construct_emoji(emoji_data)
			emojis[emoji.id] = emoji
		parsed_data["emojis"] = emojis
	
	for presence_data in data.get("presences", []):
		var _presence: Presence = manager.get_or_construct_presence(presence_data, true)
	
	if data.has("voice_states"):
		var voice_states: Dictionary = guild.voice_states if guild else {}
		for state_data in data["voice_states"]:
			state_data["guild_id"] = guild_id
			var state: Guild.VoiceState = construct_voice_state(state_data)
			voice_states[state.id] = state
		parsed_data["voice_states"] = voice_states
	
	if data.has("large"):
		parsed_data["is_large"] = data["large"]
	if data.has("unavailable"):
		parsed_data["unavailable"] = data["unavailable"]
	if data.has("member_count"):
		parsed_data["member_count"] = data["member_count"]
	if data.has("threads"):
		var threads_ids: Array = []
		for thread_data in data["threads"]:
			var thread: Guild.ThreadChannel = manager.get_or_construct_channel(thread_data)
			threads_ids.append(thread.id)
		parsed_data["threads"] = threads_ids
	
	return parsed_data

func parse_guild_member_payload(data: Dictionary) -> Dictionary:
	var user: User = get_manager().get_or_construct_user(data["user"])
	var guild_id = data["guild_id"]
	
	var parsed_data: Dictionary = {
		id = user.id,
		guild_id = guild_id,
		roles_ids = Snowflake.snowflakes2integers(data["roles"]),
		join_date = TimeUtil.iso_to_unix(data["joined_at"])
	}
	
	if data.has("deaf"):
		parsed_data["is_deafened"] = data["deaf"]
	
	if data.has("mute"):
		parsed_data["is_muted"] = data["mute"]
		
	if Dictionaries.has_non_null(data, "nick"):
		parsed_data["nickname"] = data["nick"]
	
	if Dictionaries.has_non_null(data, "avatar"):
		parsed_data["avatar_hash"] = data["avatar"]
	
	if Dictionaries.has_non_null(data, "premium_since"):
		parsed_data["premium_since"] = TimeUtil.iso_to_unix(data["premium_since"])
	
	if data.has("pending"):
		parsed_data["pending"] = data["pending"]
	
	return parsed_data

func parse_role_payload(data: Dictionary) -> Dictionary:
	return {
		id = data["id"] as int,
		name = data["name"],
		guild_id = data["guild_id"],
		color = Colors.from_rgb24(int(data["color"])),
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

func parse_voice_state_payload(data: Dictionary) -> Dictionary:
	var guild_id: int = data["guild_id"] as int
	var user_id: int = data["user_id"] as int
	var member: Guild.Member = null
	if data.has("member"):
		var member_data: Dictionary = data["member"]
		member_data["id"] = data["user_id"]
		member_data["guild_id"] = guild_id
		member = get_manager().get_or_construct_guild_member(member_data)
	
	var parsed_data: Dictionary = {
		user_id = user_id,
		guild_id = guild_id,
		channel_id = Dictionaries.get_non_null(data, "channel_id", 0) as int,
		member = member,
		session_id = data["session_id"],
		deaf = data["deaf"],
		mute = data["mute"],
		self_deaf = data["self_deaf"],
		self_mute = data["self_mute"],
		self_stream = data.get("self_stream", false),
		self_video = data.get("self_video"),
		suppress = data["suppress"],
		request_to_speak = TimeUtil.iso_to_unix(Dictionaries.get_non_null(data, "request_to_speak_timestamp", ""))
	}
	
	return parsed_data

func get_class() -> String:
	return "GuildManager"

static func _convert_features_strings(strings: Array) -> PoolIntArray:
	var features: PoolIntArray = []
	for feature in strings:
		features.append(Guild.Features[feature])
	return features
