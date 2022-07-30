class_name Guild extends DiscordEntity

enum MessageNotificationLevel {
	ALL_MESSAGES,
	ONLY_MENTIONS
}

enum ExplicitContentFilterLevel {
	DISABLED,
	MEMBERS_WITHOUT_ROLES,
	ALL_MEMBERS
}

enum MFALevel {
	NONE,
	ELEVATED
}

enum VerificationLevel {
	NONE,
	LOW,
	MEDIUM,
	HIGH,
	VERY_HIGH
}

enum NSFWLevel {
	DEFAULT,
	EXPLICIT,
	SAFE,
	AGE_RESTRICTED
}

enum PremiumTier {
	NONE,
	TIER_1,
	TIER_2,
	TIER_3
}

enum SystemChannelFlags {
	SUPPRESS_JOIN_NOTIFICATIONS           = 1 << 0,
	SUPPRESS_PREMIUM_SUBSCRIPTIONS        = 1 << 1,
	SUPPRESS_GUILD_REMINDER_NOTIFICATIONS = 1 << 2
}

enum Features {
	ANIMATED_ICON,
	BANNER,
	COMMERCE,
	COMMUNITY,
	DISCOVERABLE,
	FEATURABLE,
	INVITE_SPLASH,
	MEMBER_VERIFICATION_GATE_ENABLED,
	MONETIZATION_ENABLED,
	MORE_STICKERS,
	NEWS,
	PARTNERED,
	PREVIEW_ENABLED,
	PRIVATE_THREADS,
	ROLE_ICONS,
	SEVEN_DAY_THREAD_ARCHIVE,
	THREE_DAY_THREAD_ARCHIVE,
	TICKETED_EVENTS_ENABLED,
	VANITY_URL,
	VERIFIED,
	VIP_REGIONS,
	WELCOME_SCREEN_ENABLED,
}

var _members: Dictionary
var _roles: Dictionary
var _emojis: Dictionary
var _stage_instances: Dictionary
var _stickers: Dictionary
var _scheduled_events: Dictionary

var name: String
var description: String
var owner_id: int
var owner: Member:
	get: return get_member(owner_id)
var icon_hash: String
var splash_hash: String
var discovery_splash_hash: String
var afk_channel_id: int
var afk_channel: GuildVoiceChannel:
	get: return get_channel(afk_channel_id)
var afk_timeout: int
var widget_enabled: bool
var widget_channel_id: int
var widget_channel: Channel:
	get: return get_channel(widget_channel_id)
var verification_level: int
var default_message_notifications: int
var explicit_content_filter: int
var roles: Array[Role]:
	get: return _roles.values()
var emojis: Array[GuildEmoji]:
	get: return _emojis.values()
var features: PackedInt32Array
var mfa_level: int
var application_id: int
var system_channel_id: int
var system_channel: GuildTextChannel:
	get: return get_channel(system_channel_id)
var system_channel_flags: BitFlag
var rules_channel_id: int
var rules_channel: GuildTextChannel:
	get: return get_channel(rules_channel_id)
var is_large: bool
var unavailable: bool
var member_count: int
var voice_states: Dictionary
var members: Array[Member]
var channels_ids: Array[int]
var threads_ids: Array[int]
var channels: Array[Channel]:
	get: return get_channels()
var max_presences: int
var max_members: int
var vanity_url_code: String
var banner_hash: String
var premium_tier: int
var premium_subscription_count: int
var preferred_locale: String
var public_updates_channel_id: int
var public_updates_channel: GuildTextChannel:
	get: return get_channel(public_updates_channel_id)
var max_video_channel_users: int
var welcome_screen: WelcomeScreen
var nsfw_level: int
var threads: Array[ThreadChannel]:
	get = get_threads
var stage_instances: Array[StageInstance]:
	get: return _stage_instances.values()
var stickers: Array:
	get: return _stickers.values()
var scheduled_events: Array[GuildScheduledEvent]:
	get: return _scheduled_events.values()
var progress_bar_enabled: bool

func _init(data: Dictionary) -> void:
	super(data["id"])
	system_channel_flags = BitFlag.new(SystemChannelFlags)
	_update(data)

func has_feature(feature: int) -> bool:
	return feature in self.features

func get_channel(channel_id: int) -> Channel:
	var channel: Channel = self.get_container().channels.get(channel_id)
	if channel and channel.is_guild() and channel.guild.id == self.id:
		return channel
	return null

func get_channels(sort: bool = false) -> Array:
	var all_channels: Dictionary = get_container().channels
	var _channels: Array = []
	for channel_id in channels_ids:
		var channel: Channel = all_channels.get(channel_id)
		if channel:
			_channels.append(channel)
	if sort:
		#not implemented
		pass

	return _channels

func get_member(member_id: int) -> Member:
	return self._members.get(member_id)

func get_members() -> Array:
	return self._members.values()

func get_role(role_id: int) -> Role:
	return self._roles.get(role_id)

func get_default_role() -> Role:
	return get_role(self.id)

func get_emoji(emoji_id: int) -> GuildEmoji:
	return self._emojis.get(emoji_id)

func get_threads() -> Array[ThreadChannel]:
	var _threads: Array[ThreadChannel]
	for thread_id in threads_ids:
		_threads.append(get_thread(thread_id))
	return _threads

func get_thread(thread_id: int) -> ThreadChannel:
	return get_channel(thread_id) as ThreadChannel

func get_stage_instance(stage_id: int) -> StageInstance:
	return _stage_instances.get(stage_id)

func get_sticker(sticker_id: int) -> Object:
	return _stickers.get(sticker_id)

func get_scheduled_event(event_id: int) -> GuildScheduledEvent:
	return _scheduled_events.get(event_id)

func get_icon_url(format: String = "png", size: int = 128) -> String:
	if not has_icon():
		return ""
	return Discord.CDN_URL + DiscordREST.ENDPOINTS.GUILD_ICON.format({
		"guild_id": self.id,
		"hash": icon_hash + "." + format + "?size=" + str(size)
	})

func get_icon(format: String = "png", size: int = 128) -> Texture:
	if not has_icon():
		return await Awaiter.submit()
	return await get_rest().cdn_download_async(
		get_icon_url(format, size)) as Texture

func edit(data: GuildEditData) -> Guild:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	var fail: bool = false
	if not self_permissions.MANAGE_GUILD:
		fail = true
		push_error("Can not edit guild, missing MANAGE_GUILD permission")
	if data.has("splash") and not has_feature(Features.INVITE_SPLASH):
		fail = true
		push_error("Can not edit splash image, guild is missing INVITE_SPLASH feature")
	if data.has("discovery_splash") and not has_feature(Features.DISCOVERABLE):
		fail = true
		push_error("Can not edit discovery splash image, guild is missing DISCOVERABLE feature")
	if data.has("banner") and not has_feature(Features.BANNER):
		fail = true
		push_error("Can not edit banner image, guild is missing BANNER feature")
	if fail:
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild", [self.id, data.to_dict()]
	)

func delete() -> bool:
	var bot_id: int = get_container().bot_id
	if bot_id != owner_id:
		push_error("Can not delete Guild, bot must be the Guild owner")
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"delete_guild", [self.id]
	)

func fetch_channels() -> Array:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_channels", [self.id]
	)

func create_channel(data: ChannelCreateData) -> Channel:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_CHANNELS:
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"create_guild_channel", [self.id, data.to_dict()]
	)

func edit_channel_positions(data: ChannelPositionsEditData) -> bool:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_channel_positions", [self.id, data.to_array()]
	)

func fetch_member(member_id: int) -> Member:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_member", [self.id, member_id]
	)

func fetch_members(limit: int = 1, after: int = 0) -> Array:
	if limit < 1 or limit > 1000:
		push_error("fetch_member() 'limit' argument must be in range of 1 to 1000")
		await Awaiter.submit()
		return []
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"list_guild_members", [self.id, limit, after]
	)

func search_members(query: String, limit: int = 1) -> Array:
	if limit < 1 or limit > 1000:
		push_error("search_members() 'limit' argument must be in range of 1 to 1000")
		await Awaiter.submit()
		return []
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"search_guild_members", [self.id, query, limit]
	)

func add_member(user_id: int, access_token: String) -> Array:
	# TODO add the rest of parameters of this endpoint
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"add_guild_member", [self.id, user_id, {access_token = access_token}]
	)

func edit_current_member(nickname: String) ->  Member:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.CHANGE_NICKNAME:
		push_error("Can not edit nickname, missing CHANGE_NICKNAME permission")
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"edit_current_member", [self.id, {nick = nickname}]
	)

func fetch_bans() -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.BAN_MEMBERS:
		push_error("Can not fetch guild bans, missing BAN_MEMBERS permission")
		await Awaiter.submit()
		return []
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_bans", [self.id]
	)

func fetch_ban(user_id: int) -> GuildBan:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.BAN_MEMBERS:
		push_error("Can not fetch guild ban, missing BAN_MEMBERS permission")
		await Awaiter.submit()
		return
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_ban", [self.id, user_id]
	)

func fetch_roles() -> Array:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_roles", [self.id]
	)

func create_role(data: RoleCreateData) -> Role:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	var fail: bool = false
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not create role, missing MANAGE_ROLES permission")
		fail = true
	if data.has("icon") or data.has("unicode_emoji") and not has_feature(Features.ROLE_ICONS):
		push_error("Can not edit role icon, guild is missing ROLE_ICONS feature")
		fail = true
	if fail:
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"create_guild_role", [self.id, data.to_dict()]
	)

func edit_role_positions(data: RolePositionsEditData) -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not create role, missing MANAGE_ROLES permission")
		await Awaiter.submit()
		return []
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_role_positions", [self.id, data.to_array()]
	)

func fetch_prune_count(days: int = 7, role_ids: PackedStringArray = PackedStringArray()) -> int:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	var fail: bool = false
	if not self_permissions.KICK_MEMBERS:
		push_error("Can not get guild prune count, missing KICK_MEMBERS permission")
		fail = true
	if days < 1 or days > 30:
		push_error("fetch_prune_count() 'days' argument must be in range of 1 to 30")
		fail = true
	if fail:
		await Awaiter.submit()
		return -1
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_prune_count", [self.id, days, role_ids]
	)

func begin_prune(days: int = 7, return_count: bool = true, role_ids: PackedStringArray = PackedStringArray()) -> int:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	var fail: bool = false
	if not self_permissions.KICK_MEMBERS:
		push_error("Can not get guild prune count, missing KICK_MEMBERS permission")
		fail = true
	if days < 1 or days > 30:
		push_error("fetch_prune_count() 'days' argument must be in range of 1 to 30")
		fail = true
	if fail:
		await Awaiter.submit()
		return -1
	var options: Dictionary = {
		days = days,
		compute_prune_count = return_count,
		include_roles = role_ids
	}
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"begin_guild_prune", [self.id, options]
	)

func fetch_voice_regions() -> Array:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_voice_regions", [self.id]
	)

func fetch_invites() -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_GUILD:
		push_error("Can not get guild invites, missing MANAGE_GUILD permission")
		await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_invites", [self.id]
	)

func fetch_vanity_url() -> Invite:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_GUILD:
		push_error("Can not get vanity url, missing MANAGE_GUILD permission")
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_vanity_url", [self.id]
	)

func fetch_widget_image(style: String = "shield") -> Texture:
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_widget_image", [self.id, style]
	)

func has_member(member_id: int) -> bool:
	return _members.has(member_id)

func has_icon() -> bool:
	return not icon_hash.is_empty()

func get_class() -> String:
	return "Guild"

func _add_channel(id: int) -> void:
	if not channels_ids.has(id):
		channels_ids.append(id)

func _remove_channel(id: int) -> void:
	channels_ids.erase(id)

func _update(data: Dictionary) -> void:
	name = data.get("name", name)
	icon_hash = data.get("icon_hash", icon_hash)
	splash_hash = data.get("splash_hash", splash_hash)
	discovery_splash_hash = data.get("discovery_splash_hash", discovery_splash_hash)
	afk_timeout = data.get("afk_timeout", afk_timeout)
	widget_enabled = data.get("widget_enabled", widget_enabled)
	verification_level = data.get("verification_level", verification_level)
	default_message_notifications = data.get("default_message_notifications", default_message_notifications)
	explicit_content_filter = data.get("explicit_content_filter", explicit_content_filter)
	features = data.get("features", features)
	mfa_level = data.get("mfa_level", mfa_level)
	owner_id = data.get("owner_id", owner_id)
	application_id = data.get("application_id", application_id)
	vanity_url_code = data.get("vanity_url_code", vanity_url_code)
	description = data.get("description", description)
	banner_hash = data.get("banner_hash" , banner_hash)
	premium_tier = data.get("premium_tier", premium_tier)
	system_channel_flags.flags = data.get("system_channel_flags", system_channel_flags.flags)
	preferred_locale = data.get("preferred_locale", preferred_locale)
	nsfw_level = data.get("nsfw_level", nsfw_level)
	
	is_large = data.get("is_large", is_large)
	unavailable = data.get("unavailable", unavailable)
	member_count = data.get("member_count", member_count)
	max_members = data.get("max_members", max_members)
	premium_subscription_count = data.get("premium_subscription_count", premium_subscription_count)
	max_presences = data.get("max_presences", max_presences)
	max_video_channel_users = data.get("max_video_channel_users", max_video_channel_users)
	voice_states = data.get("voice_states", voice_states)
	
	_members = data.get("members", _members)
	_roles = data.get("roles", _roles)
	_emojis = data.get("emojis", _emojis)
	channels_ids = data.get("channels_ids", channels_ids)
	threads_ids = data.get("threads_ids", threads_ids)
	
	afk_channel_id = data.get("afk_channel_id", afk_channel_id)
	widget_channel_id = data.get("widget_channel_id", widget_channel_id)
	system_channel_id = data.get("system_channel_id", system_channel_id)
	rules_channel_id = data.get("rules_channel_id", rules_channel_id)
	public_updates_channel_id = data.get("public_updates_channel_id", public_updates_channel_id)
	
	welcome_screen = data.get("welcome_screen", welcome_screen)
	
	_stage_instances = data.get("stage_instances", _stage_instances)
	_stickers = data.get("stickers", _stickers)
	_scheduled_events = data.get("scheduled_events", _scheduled_events)
	progress_bar_enabled = data.get("progress_bar_enabled", progress_bar_enabled)

func _clone_data() -> Array:
	return [{
		id = self.id,
		name = self.name,
		description = self.description,
		owner_id = self.owner_id,
		icon_hash = self.icon_hash,
		splash_hash = self.splash_hash,
		discovery_splash_hash = self.discovery_splash_hash,
		afk_channel_id = self.afk_channel_id,
		afk_timeout = self.afk_timeout,
		widget_enabled = self.widget_enabled,
		widget_channel_id = self.widget_channel_id,
		verification_level = self.verification_level,
		default_message_notifications = self.default_message_notifications,
		explicit_content_filter = self.explicit_content_filter,
		features = self.features,
		mfa_level = self.mfa_level,
		application_id = self.application_id,
		system_channel_id = self.system_channel_id,
		system_channel_flags = self.system_channel_flags.flags,
		rules_channel_id = self.rules_channel_id,
		is_large = self.is_large,
		unavailable = self.unavailable,
		member_count = self.member_count,
		voice_states = self.voice_states.duplicate(),
		max_presences = self.max_presences,
		max_members = self.max_members,
		vanity_url_code = self.vanity_url_code,
		banner_hash = self.banner_hash,
		premium_tier = self.premium_tier,
		premium_subscription_count = self.premium_subscription_count,
		preferred_locale = self.preferred_locale,
		public_updates_channel_id = self.public_updates_channel_id,
		max_video_channel_users = self.max_video_channel_users,
		nsfw_level = self.nsfw_level,
		
		channels_ids = self.channels_ids.duplicate(),
		members = self._members.duplicate(),
		roles = self._roles.duplicate(),
		emojis = self._emojis.duplicate(),
		
		welcome_screen = self.welcome_screen,
		
		threads = self._threads.duplicate(),
		stage_instances = self._stage_instances.duplicate(),
		stickers = self._stickers.duplicate(),
		scheduled_events = self._scheduled_events.duplicate(),
		progress_bar_enabled = self.progress_bar_enabled
	}]
