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

var _members: Dictionary                     setget __set
var _roles: Dictionary                       setget __set
var _emojis: Dictionary                      setget __set

var name: String                             setget __set
var description: String                      setget __set
var owner_id: int                            setget __set
var owner: Member                            setget __set, get_owner
var icon_hash: String                        setget __set
var splash_hash: String                      setget __set
var discovery_splash_hash: String            setget __set
var afk_channel_id: int                      setget __set
var afk_channel: GuildVoiceChannel           setget __set, get_afk_channel
var afk_timeout: int                         setget __set
var widget_enabled: bool                     setget __set
var widget_channel_id: int                   setget __set
var widget_channel: Channel                  setget __set, get_widget_channel
var verification_level: int                  setget __set
var default_message_notifications: int       setget __set
var explicit_content_filter: int             setget __set
var roles: Array                             setget __set, get_roles
var emojis: Array                            setget __set, get_emojis
var features: PoolIntArray                   setget __set
var mfa_level: int                           setget __set
var application_id: int                      setget __set
var system_channel_id: int                   setget __set
var system_channel: GuildTextChannel         setget __set, get_system_channel
var system_channel_flags: BitFlag            setget __set
var rules_channel_id: int                    setget __set
var rules_channel: GuildTextChannel          setget __set, get_rules_channel
var is_large: bool                           setget __set
var unavailable: bool                        setget __set
var member_count: int                        setget __set
var voice_states: Dictionary                 setget __set
var members: Array                           setget __set, get_members
var channels_ids: Array                      setget __set
var channels: Array                          setget __set, get_channels
var max_presences: int                       setget __set
var max_members: int                         setget __set
var vanity_url_code: String                  setget __set
var banner_hash: String                      setget __set
var premium_tier: int                        setget __set
var premium_subscription_count: int          setget __set
var preferred_locale: String                 setget __set
var public_updates_channel_id: int           setget __set
var public_updates_channel: GuildTextChannel setget __set, get_public_updates_channel
var max_video_channel_users: int             setget __set
var welcome_screen: WelcomeScreen            setget __set
var nsfw_level: int                          setget __set

func _init(data: Dictionary).(data.id) -> void:
	system_channel_flags = BitFlag.new(SystemChannelFlags)
	_update(data)

func has_feature(feature: int) -> bool:
	return feature in self.features

func get_channel(channel_id: int) -> Channel:
	var channel: Channel = self.get_container().channels.get(channel_id)
	if channel and channel.has_method("get_guild") and channel.guild.id == self.id:
		return channel
	return null

func get_channels(sort: bool = false) -> Array:
	var all_channels: Dictionary = self.get_container().channels
	var _channels: Array = []
	for channel_id in channels_ids:
		var channel: Channel = all_channels.get(channel_id)
		if channel:
			_channels.append(channel)
	if sort:
		#not implemented
		pass
	
	return _channels

func get_afk_channel() -> GuildVoiceChannel:
	var channel: Channel = self.get_channel(afk_channel_id)
	if channel is GuildVoiceChannel:
		return channel as GuildVoiceChannel
	return null

func get_widget_channel() -> Channel:
	return self.get_channel(widget_channel_id)

func get_system_channel() -> GuildTextChannel:
	var channel: Channel = self.get_channel(system_channel_id)
	if channel is GuildTextChannel:
		return channel as GuildTextChannel
	return null

func get_rules_channel() -> GuildTextChannel:
	var channel: Channel = self.get_channel(rules_channel_id)
	if channel is GuildTextChannel:
		return channel as GuildTextChannel
	return null

func get_public_updates_channel() -> GuildTextChannel:
	var channel: Channel = self.get_channel(public_updates_channel_id)
	if channel is GuildTextChannel:
		return channel as GuildTextChannel
	return null

func get_member(member_id: int) -> Member:
	return self._members.get(member_id)

func get_members() -> Array:
	return self._members.values()

func get_owner() -> Member:
	return self.get_member(owner_id)

func get_roles() -> Array:
	return self._roles.values()

func get_role(id: int) -> Role:
	return self._roles.get(id)

func get_default_role() -> Role:
	return get_role(self.id)

func get_emojis() -> Array:
	return self._emojis.values()

func get_emoji(id: int) -> GuildEmoji:
	return self._emojis.get(id)

func get_icon_url(format: String = "png", size: int = 128) -> String:
	if not has_icon():
		return ""
	return Discord.CDN_URL + DiscordREST.ENDPOINTS.GUILD_ICON.format({
		"guild_id": self.id,
		"hash": icon_hash + "." + format + "?size=" + str(size)
	})

func get_icon(format: String = "png", size: int = 128) -> Texture:
	if not has_icon():
		return Awaiter.submit()
	return yield(get_rest().cdn_download_async(
		get_icon_url(format, size))
	, "completed") as Texture

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
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild", [self.id, data.to_dict()]
	)

func delete() -> bool:
	var bot_id: int = get_container().bot_id
	if bot_id != owner_id:
		push_error("Can not delete Guild, bot must be the Guild owner")
		yield(Awaiter.submit(), "completed")
		return false
	return get_rest().request_async(
		DiscordREST.GUILD,
		"delete_guild", [self.id]
	)

func fetch_channels() -> Array:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_channels", [self.id]
	)

func create_channel(data: ChannelCreateData) -> Channel:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_CHANNELS:
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"create_guild_channel", [self.id, data.to_dict()]
	)

func edit_channel_positions(data: ChannelPositionsEditData) -> bool:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_channel_positions", [self.id, data.to_array()]
	)

func fetch_member(member_id: int) -> Member:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_member", [self.id, member_id]
	)

func fetch_members(limit: int = 1, after: int = 0) -> Array:
	if limit < 1 or limit > 1000:
		push_error("fetch_member() 'limit' argument must be in range of 1 to 1000")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"list_guild_members", [self.id, limit, after]
	)

func search_members(query: String, limit: int = 1) -> Array:
	if limit < 1 or limit > 1000:
		push_error("search_members() 'limit' argument must be in range of 1 to 1000")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"search_guild_members", [self.id, query, limit]
	)

func add_member(user_id: int, access_token: String) -> Array:
	# TODO add the rest of parameters of this endpoint
	return get_rest().request_async(
		DiscordREST.GUILD,
		"add_guild_member", [self.id, user_id, {access_token = access_token}]
	)

func edit_current_member(nickname: String) ->  Guild.Member:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.CHANGE_NICKNAME:
		push_error("Can not edit nickname, missing CHANGE_NICKNAME permission")
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_current_member", [self.id, {nick = nickname}]
	)

func fetch_bans() -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.BAN_MEMBERS:
		push_error("Can not fetch guild bans, missing BAN_MEMBERS permission")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_bans", [self.id]
	)

func fetch_ban(user_id: int) -> GuildBan:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.BAN_MEMBERS:
		push_error("Can not fetch guild ban, missing BAN_MEMBERS permission")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_ban", [self.id, user_id]
	)

func fetch_roles() -> Array:
	return get_rest().request_async(
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
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"create_guild_role", [self.id, data.to_dict()]
	)

func edit_role_positions(data: RolePositionsEditData) -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not create role, missing MANAGE_ROLES permission")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_role_positions", [self.id, data.to_array()]
	)

func fetch_prune_count(days: int = 7, role_ids: PoolStringArray = []) -> int:
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
		yield(Awaiter.submit(), "completed")
		return -1
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_prune_count", [self.id, days, role_ids]
	)

func begin_prune(days: int = 7, return_count: bool = true, role_ids: PoolStringArray = []) -> int:
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
		yield(Awaiter.submit(), "completed")
		return -1
	var options: Dictionary = {
		days = days,
		compute_prune_count = return_count,
		include_roles = role_ids
	}
	return get_rest().request_async(
		DiscordREST.GUILD,
		"begin_guild_prune", [self.id, options]
	)

func fetch_voice_regions() -> Array:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_voice_regions", [self.id]
	)

func fetch_invites() -> Array:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_GUILD:
		push_error("Can not get guild invites, missing MANAGE_GUILD permission")
		yield(Awaiter.submit(), "completed")
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_invites", [self.id]
	)

func fetch_vanity_url() -> Invite:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_GUILD:
		push_error("Can not get vanity url, missing MANAGE_GUILD permission")
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_vanity_url", [self.id]
	)

func fetch_widget_image(style: String = "shield") -> Texture:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_widget_image", [self.id, style]
	)

func has_member(member_id: int) -> bool:
	return _members.has(member_id)

func has_icon() -> bool:
	return not icon_hash.empty()

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
	
	afk_channel_id = data.get("afk_channel_id", afk_channel_id)
	widget_channel_id = data.get("widget_channel_id", widget_channel_id)
	system_channel_id = data.get("system_channel_id", system_channel_id)
	rules_channel_id = data.get("rules_channel_id", rules_channel_id)
	public_updates_channel_id = data.get("public_updates_channel_id", public_updates_channel_id)
	
	welcome_screen = data.get("welcome_screen", welcome_screen)

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
		emojis = self._emojis.duplicate()
	}]

func __set(_value) -> void:
	pass

class Member extends MentionableEntity:
	var user: User          setget __set, get_user
	var nickname: String    setget __set, get_nickname
	var avatar_hash: String setget __set, get_avatar_hash
	var guild_id: int       setget __set
	var guild: Guild        setget __set, get_guild
	var roles_ids: Array    setget __set
	var roles: Array        setget __set, get_roles
	var presence: Presence  setget __set, get_presence
	var join_date: int      setget __set
	var premium_since: int  setget __set
	var is_deafened: bool   setget __set
	var is_muted: bool      setget __set
	var pending: bool       setget __set
	
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		join_date = data["join_date"]
		_update(data)
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_mention() -> String:
		return self.user.get_mention()
	
	func get_nickname_mention() -> String:
		return self.user.get_nickname_mention()
	
	func get_nickname() -> String:
		return self.user.username if nickname.empty() else nickname
	
	func get_avatar_hash() -> String:
		return avatar_hash if not avatar_hash.empty() else self.user.avatar_hash
	
	func get_roles() -> Array:
		var _roles: Array
		for role_id in self.roles_ids:
			var role: Role = self.guild.get_role(role_id)
			if role:
				_roles.append(role)
		return _roles
	
	func get_user() -> User:
		return self.get_container().users.get(self.id)
	
	func get_presence() -> Presence:
		return self.get_container().presences.get(self.id)
	
	func get_partial_voice_state() -> VoiceState:
		var state: VoiceState = VoiceState.new({
			user_id = self.id,
			guild_id = guild_id,
			is_deafened = is_deafened,
			is_muted = is_muted
		})
		state.set_meta("partial", true)
		return state
	
	func get_voice_state() -> VoiceState:
		if self.guild.voice_states.has(self.id):
			return guild.voice_states[self.id]
		return get_partial_voice_state()
	
	func get_permissions() -> BitFlag:
		var _enum: Dictionary = Permissions.get_script_constant_map()
		# warning-ignore:narrowing_conversion
		var all: int = pow(2, _enum.size()) - 1
		
		var permissions: BitFlag
		if is_owner():
			permissions = BitFlag.new(_enum)
			permissions.flags = all
		else:
			var default_role: Role = self.guild.get_default_role()
			permissions = default_role.permissions.clone()
			for role in self.roles:
				# warning-ignore:return_value_discarded
				permissions.put(role.permissions.flags)
			if permissions.has(Permissions.ADMINISTRATOR):
				permissions.flags = all
		return permissions
	
	func permissions_in(channel_id: int) -> BitFlag:
		var base_permissions: BitFlag = get_permissions()
		if base_permissions.ADMINISTRATOR:
			return base_permissions
		
		var permissions: BitFlag = base_permissions.clone()
		
		var channel: Channel = self.guild.get_channel(channel_id)
		if not channel:
			push_error("Channel with id '%d' was not found in guild with id '%d'" % [channel_id, guild_id])
			return permissions
		
		var default_overwrite: PermissionOverwrite = channel.overwrites.get(guild_id)
		if default_overwrite:
			# warning-ignore:return_value_discarded
			permissions.clear(default_overwrite.deny.flags)\
						.put(default_overwrite.allow.flags)
		
		var allow: int = 0
		var deny: int = 0
		for role_id in roles_ids:
			var overwrite: PermissionOverwrite = channel.overwrites.get(role_id)
			if overwrite:
				allow |= overwrite.allow.flags
				deny |= overwrite.deny.flags
		
		# warning-ignore:return_value_discarded
		permissions.clear(deny).put(allow)
		
		var member_overwrite: PermissionOverwrite = channel.overwrites.get(self.id)
		if member_overwrite:
			# warning-ignore:return_value_discarded
			permissions.clear(member_overwrite.deny.flags)\
						.put(member_overwrite.allow.flags)
		
		return permissions
	
	func is_owner() -> bool:
		return self.guild.owner_id == self.id
	
	func has_role(id: int) -> bool:
		return id in self.roles_ids
	
	func edit(data: GuildMemberEditData) -> Member:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		
		var fail: bool = false
		if data.has("nick") and not self_permissions.MANAGE_NICKNAMES:
			push_error("Can not edit member nickname, missing MANAGE_NICKNAMES permission")
			fail = true
		if data.has("roles") and not self_permissions.MANAGE_ROLES:
			push_error("Can not edit member roles, missing MANAGE_ROLES permission")
			fail = true
		if data.has("mute") and not self_permissions.MUTE_MEMBERS:
			push_error("Can not mute member, missing MUTE_MEMBERS permission")
			fail = true
		if data.has("deaf") and not self_permissions.DEAFEN_MEMBERS:
			push_error("Can not deafen member, missing DEAFEN_MEMBERS permission")
			fail = true
		if data.has("channel_id") and not self_permissions.MOVE_MEMBERS:
			push_error("Can not move member, missing MOVE_MEMBERS permission")
			fail = true
		if data.has("communication_disabled_until") and not self_permissions.MODERATE_MEMBERS:
			push_error("Can not timeout member, missing MODERATE_MEMBERS permission")
			fail = true
		if fail:
			return Awaiter.submit()
		
		return get_rest().request_async(
			DiscordREST.GUILD,
			"edit_guild_member", [guild_id, self.id, data.to_dict()]
		)
	
	func assign_role(role_id: int) -> bool:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		
		var fail: bool = false
		if not self_permissions.MANAGE_ROLES:
			push_error("Can not assign role, missing MANAGE_ROLES permission")
			fail = true
		elif has_role(role_id):
			push_error("Member already has the role '%d'" % role_id)
			fail = true
		elif self.guild._roles.has(role_id):
			push_error("Role with id '%d' does not exist in guild '%d'" % [role_id, guild_id])
			fail = true
		if fail:
			yield(Awaiter.submit(), "completed")
			return false
		return get_rest().request_async(
			DiscordREST.GUILD,
			"add_guild_member_role", [guild_id, self.id, role_id]
		)
	
	func revoke_role(role_id: int) -> bool:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		
		var fail: bool = false
		if not self_permissions.MANAGE_ROLES:
			push_error("Can not revoke role, missing MANAGE_ROLES permission")
			fail = true
		elif not has_role(role_id):
			push_error("Member does not have role with '%d', can not revoke it" % role_id)
			fail = true
		elif self.guild._roles.has(role_id):
			push_error("Role with id '%d' does not exist in guild '%d'" % [role_id, guild_id])
			fail = true
		if fail:
			yield(Awaiter.submit(), "completed")
			return false
		return get_rest().request_async(
			DiscordREST.GUILD,
			"remove_guild_member_role", [guild_id, self.id, role_id]
		)
	
	func kick() -> bool:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		if not self_permissions.KICK_MEMBERS:
			push_error("Can not kick member, missing KICK_MEMBERS permission")
			yield(Awaiter.submit(), "completed")
			return false
		return get_rest().request_async(
			DiscordREST.GUILD,
			"remove_guild_member", [guild_id, self.id]
		)
	
	func ban() -> bool:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		if not self_permissions.BAN_MEMBERS:
			push_error("Can not ban member, missing BAN_MEMBERS permission")
			yield(Awaiter.submit(), "completed")
			return false
		return get_rest().request_async(
			DiscordREST.GUILD,
			"create_guild_ban", [guild_id, self.id]
		)
	
	func _update_presence(_presence: Presence) -> void:
		presence = _presence
	
	func get_class() -> String:
		return "Guild.Member"
	
	func _clone_data() -> Array:
		return [{
			id = self.id,
			nickname = nickname,
			avatar_hash = avatar_hash,
			guild_id = self.guild_id,
			role_ids = self.roles_ids.duplicate(),
			join_date = self.join_date,
			premium_since = self.premium_since,
			is_deafened = self.is_deafened,
			is_muted = self.is_muted,
			pending = self.pending
		}]
	
	func _update(data: Dictionary) -> void:
		nickname = data.get("nickname", nickname)
		avatar_hash = data.get("nickname", avatar_hash)
		roles_ids = data.get("roles_ids", roles_ids)
		premium_since = data.get("premium_since", premium_since)
		is_deafened = data.get("is_deafened", is_deafened)
		is_muted = data.get("is_muted", is_muted)
		pending = data.get("pending", pending)
	
	func __set(_value) -> void:
		pass

class Widget:
	var enabled: bool
	var channel_id: int
	
	func get_class() -> String:
		return "Widget"

class ChannelCategory extends Channel:
	var name: String           setget __set
	var guild_id: int          setget __set
	var guild: Guild           setget __set, get_guild
	var position: int          setget __set
	var overwrites: Dictionary setget __set
	
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		_update(data)
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func edit(data: GuildChannelEditData) -> ChannelCategory:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).permissions_in(self.id)
		
		var fail: bool = false
		if not self_permissions.MANAGE_CHANNELS:
			push_error("Can not edit channel, missing MANAGE_CHANNELS permission")
			fail = true
		elif data.has("permission_overwrites") and not self_permissions.MANAGE_ROLES:
			push_error("Can not edit permission overwrites, missing MANAGE_ROLES permission")
			fail = true
		if fail:
			return Awaiter.submit()
		return get_rest().request_async(
			DiscordREST.CHANNEL,
			"edit_channel", [self.id, data.to_dict()]
		)
	
	func get_class() -> String:
		return "ChannelCategory"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		name = data.get("name", name)
		guild_id = data.get("guild_id", guild_id)
		position = data.get("position", position)
		overwrites = data.get("overwrites", overwrites)
	
	func _clone_data() -> Array:
		return [{
			id = self.id,
			name = self.name,
			guild_id = self.guild_id,
			position = self.position,
			overwrites = self.overwrites.duplicate()
		}]
	
	func __set(_value) -> void:
		pass

class BaseGuildTextChannel extends TextChannel:
	var name: String             setget __set
	var guild_id: int            setget __set
	var guild: Guild             setget __set, get_guild
	var position: int            setget __set
	var rate_limit_per_user: int setget __set
	
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_class() -> String:
		return "Guild.BaseGuildTextChannel"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		name = data.get("name", name)
		position = data.get("position", position)
		rate_limit_per_user = data.get("rate_limit_per_user", rate_limit_per_user)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["name"] = self.name
		arguments["guild_id"] = self.guild_id
		arguments["position"] = self.position
		arguments["rate_limit_per_user"] = self.rate_limit_per_user
		
		return data
	
	func __set(_value) -> void:
		pass

class GuildTextChannel extends BaseGuildTextChannel:
	var topic: String           setget __set
	var parent_id: int          setget __set
	var parent: ChannelCategory setget __set, get_parent
	var overwrites: Dictionary  setget __set
	var nsfw: bool              setget __set
	
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_TEXT
	
	func has_parent() -> bool:
		return get_parent() != null
	
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	func get_class() -> String:
		return "Guild.GuildTextChannel"
	
	func edit(data: GuildTextChannelEditData) -> GuildTextChannel:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).permissions_in(self.id)
		
		var fail: bool = false
		if not self_permissions.MANAGE_CHANNELS:
			fail = true
			push_error("Can not edit channel, missing MANAGE_CHANNELS permission")
		elif data.has("permission_overwrites") and not self_permissions.MANAGE_ROLES:
			fail = true
			push_error("Can not edit permission overwrites, missing MANAGE_ROLES permission")
		elif data.has("type") and not self.guild.has_feature(Features.NEWS):
			fail = true
			push_error("Can not convert to news channel, guild is missing NEWS feature")
		if fail:
			return Awaiter.submit()
		return get_rest().request_async(
			DiscordREST.CHANNEL,
			"edit_channel", [self.id, data.to_dict()]
		)
	
	func _update(data: Dictionary) -> void:
		._update(data)
		topic = data.get("topic", topic)
		parent_id = data.get("parent_id", parent_id)
		overwrites = data.get("overwrites", overwrites)
		nsfw = data.get("nsfw", nsfw)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["topic"] = self.topic
		arguments["parent_id"] = self.parent_id
		arguments["overwrites"] = self.overwrites.duplicate()
		arguments["nsfw"] = self.nsfw
		
		return data
	
	func __set(_value) -> void:
		pass
	
class GuildNewsChannel extends GuildTextChannel:
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_NEWS
		
	func get_class() -> String:
		return "Guild.GuildNewsChannel"

class ThreadChannel extends BaseGuildTextChannel:
	var archived: bool             setget __set
	var auto_archive_duration: int setget __set
	var archive_timestamp: int     setget __set
	var locked: bool               setget __set
	var parent_id: int             setget __set
	var parent: GuildTextChannel   setget __set, get_parent
	
	func _init(data: Dictionary).(data) -> void:
		type = data["type"]
	
	func get_parent() -> GuildTextChannel:
		return self.get_container().channels.get(self.parent_id)
	
	func get_class() -> String:
		return "Guild.ThreadChannel"
	
	func _update(data: Dictionary) -> void:
		archived = data.get("archived", archived)
		auto_archive_duration = data.get("auto_archive_duration", auto_archive_duration)
		archive_timestamp = data.get("archive_timestamp", archive_timestamp)
		locked = data.get("locked", locked)
		parent_id = data.get("parent_id", parent_id)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["archived"] = self.archived
		arguments["auto_archive_duration"] = self.auto_archive_duration
		arguments["archive_timestamp"] = self.archive_timestamp
		arguments["locked"] = self.locked
		arguments["parent_id"] = self.parent_id
		
		return data
	
	func __set(_value) -> void:
		pass

class GuildStoreChannel extends Channel:
	var name: String            setget __set
	var guild_id: int           setget __set
	var guild: Guild            setget __set, get_guild
	var position: int           setget __set
	var parent_id: int          setget __set
	var parent: ChannelCategory setget __set, get_parent
	var overwrites: Dictionary  setget __set
	
	func _init(data: Dictionary).(data["id"]) -> void:
		type = Channel.Type.GUILD_STORE
		guild_id = data["guild_id"]
		_update(data)
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	func get_class() -> String:
		return "Guild.GuildStoreChannel"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		name = data.get("name", name)
		position = data.get("position", position)
		parent_id = data.get("parent_id", parent_id)
		overwrites = data.get("overwrites", overwrites)
	
	func _clone_data() -> Array:
		return [{
			id = self.id,
			name = self.name,
			guild_id = self.guild_id,
			position = self.position,
			parent_id = self.parent_id,
			overwrites = self.overwrites.duplicate()
		}]
	
	func __set(_value) -> void:
		pass

class BaseGuildVoiceChannel extends VoiceChannel:
	var name: String                 setget __set
	var guild_id: int                setget __set
	var guild: Guild                 setget __set, get_guild
	var position: int                setget __set
	var parent_id: int               setget __set
	var parent: ChannelCategory      setget __set, get_parent
	var overwrites: Array setget __set
	
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	func edit(data: GuildVoiceChannelEditData) -> BaseGuildVoiceChannel:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).permissions_in(self.id)
		
		var fail: bool = false
		if not self_permissions.MANAGE_CHANNELS:
			push_error("Can not edit channel, missing MANAGE_CHANNELS permission")
			fail = true
		elif data.has("permission_overwrites") and not self_permissions.MANAGE_ROLES:
			push_error("Can not edit permission overwrites, missing MANAGE_ROLES permission")
			fail = true
		if fail:
			return Awaiter.submit()
		return get_rest().request_async(
			DiscordREST.CHANNEL,
			"edit_channel", [self.id, data.to_dict()]
		)
	
	func get_class() -> String:
		return "Guild.BaseGuildVoiceChannel"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		name = data.get("name", name)
		position = data.get("position", position)
		parent_id = data.get("parent_id", parent_id)
		overwrites = data.get("overwrites", overwrites)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["name"] = self.name
		arguments["guild_id"] = self.guild_id
		arguments["position"] = self.position
		arguments["parent_id"] = self.parent_id
		arguments["overwrites"] = self.overwrites.duplicate()
		
		return data
	
	func __set(_value) -> void:
		pass

class GuildVoiceChannel extends BaseGuildVoiceChannel:
	var user_limit: int    setget __set
	var video_quality: int setget __set
	
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_VOICE
	
	func get_class() -> String:
		return "GuildVoiceChannel"
	
	func _update(data: Dictionary) -> void:
		user_limit = data.get("user_limit", user_limit)
		video_quality = data.get("var video_quality", video_quality)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["user_limit"] = self.user_limit
		arguments["video_quality"] = self.video_quality
		
		return data
	
	func __set(_value) -> void:
		pass

class StageChannel extends BaseGuildVoiceChannel:
	var topic: String            setget __set
	var instance: StageInstance setget __set
	
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_STAGE_VOICE
		
	func get_class() -> String:
		return "Guild.StageChannel"
	
	func _update(data: Dictionary) -> void:
		topic = data.get("topic", topic)
		instance = data.get("instance", instance)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["topic"] = self.topic
		arguments["instance"] = self.instance
		
		return data
	
	func __set(_value) -> void:
		pass

class StageInstance extends DiscordEntity:
	enum PrivacyLevel {
		PUBLIC,
		GUILD_ONLY
	}
	
	var guild_id: int         setget __set
	var guild: Guild          setget __set, get_guild
	var channel_id: int       setget __set
	var channel: StageChannel setget __set, get_channel
	var topic: String         setget __set
	var privacy_level: int    setget __set
	var discoverable: bool    setget __set
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_channel() -> StageChannel:
		var _channel: Channel = self.guild.get_channel(channel_id)
		if _channel is StageChannel:
			return _channel as StageChannel
		return null
	
	func __set(_value) -> void:
		pass

class Role extends MentionableEntity:
	var name: String         setget __set
	var color: Color         setget __set
	var hoist: bool          setget __set
	var position: int        setget __set
	var permissions: BitFlag setget __set
	var is_managed: bool     setget __set
	var mentionable: bool    setget __set
	var tags: Tags           setget __set
	var guild_id: int        setget __set
	var guild: Guild         setget __set, get_guild
	
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		permissions = BitFlag.new(Permissions.get_script_constant_map())
		_update(data)
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	func get_mention() -> String:
		return "<@&%d>" % self.get_id()
	
	func edit(data: RoleEditData) -> Role:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		if not self_permissions.MANAGE_ROLES:
			push_error("Can not edit role, missing MANAGE_ROLES permission")
			return Awaiter.submit()
		return get_rest().request_async(
			DiscordREST.GUILD,
			"edit_guild_role", [guild_id, self.id, data.to_dict()]
		)
	
	func delete() -> bool:
		var bot_id: int = get_container().bot_id
		var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
		if not self_permissions.MANAGE_ROLES:
			push_error("Can not delete role, missing MANAGE_ROLES permission")
			yield(Awaiter.submit(), "completed")
			return false
		return get_rest().request_async(
			DiscordREST.GUILD,
			"delete_guild_role", [guild_id, self.id]
		)
	
	func get_class() -> String:
		return "Guild.Role"
	
	func _clone_data() -> Array:
		return [{
			id = self.id,
			name = self.name,
			guild_id = self.guild_id,
			hoist = self.hoist,
			position = self.position,
			permissions = self.permissions.flags,
			is_managed = self.is_managed,
			mentionable = self.mentionable,
			tags = self.tags.duplicate() if tags else null,
		}]
	
	func _update(data: Dictionary) -> void:
		name = data.get("name", name)
		color = data.get("color", color)
		hoist = data.get("hoist", hoist)
		position = data.get("position", position)
		permissions.flags = data.get("permissions", permissions.flags)
		is_managed = data.get("is_managed", is_managed)
		mentionable = data.get("mentionable", mentionable)
		tags = data.get("tags", tags)
	
	func __set(_value) -> void:
		pass
	
	class Tags:
		var bot_id: int              setget __set
		var integration_id: int      setget __set
		var premium_subscriber: bool setget __set
	
		func _init(data: Dictionary) -> void:
			bot_id = data["bot_id"]
			integration_id = data["integration_id"]
			premium_subscriber = data["premium_subscriber"]
		
		func duplicate() -> Tags:
			return self.get_script().new({
				bot_id = self.bot_id,
				integration_id = self.integration_id,
				premium_subscriber = self.premium_subscriber
			})
		
		func get_class() -> String:
			return "Guild.Role.Tags"
		
		func _to_string() -> String:
			return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
		
		func __set(_value) -> void:
			pass

class GuildEmoji extends Emoji:
	var guild_id: int     setget __set
	var guild: Guild      setget __set, get_guild
	var roles_ids: Array  setget __set
	var roles: Array      setget __set, get_roles
	var user_id: int      setget __set
	var user: User        setget __set, get_user
	var is_managed: bool  setget __set
	var is_animated: bool setget __set
	var available: bool   setget __set
	
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
		user_id = data["user_id"]
		is_managed = data.get("is_managed", false)
		is_animated = data.get("is_animated", false)
		available = data.get("available", false)
	
	func get_mention() -> String:
		return ("<a:%s:%d>" if self.is_animated else "<:%s:%d>") % [self.name, self.id]
	
	func get_guild() -> Guild:
		return self.get_container().guilds.get(self.guild_id)
	
	func get_roles() -> Array:
		var _roles: Array
		for role_id in self.roles_ids:
			var role: Role = self.guild.get_role(role_id)
			if role:
				_roles.append(role)
		return _roles
	
	func get_user() -> User:
		return self.get_container().users.get(self.user_id)
	
	func url_encoded() -> String:
		return ("%s:%d" % [name, self.id]).http_escape()
	
	func get_class() -> String:
		return "Guild.GuildEmoji"
	
	func _clone_data() -> Array:
		return [{
			id = self.id,
			name = self.name,
			guild_id = self.guild_id,
			roles_ids = self.roles_ids.duplicate(),
			user_id = self.user_id,
			permissions = self.permissions,
			is_managed = self.is_managed,
			is_animated = self.is_animated,
			available = self.available,
		}]
	
	func __set(_value) -> void:
		pass

class VoiceState extends DiscordEntity:
	var guild_id: int              setget __set
	var guild: Guild               setget __set, get_guild
	var channel_id: int            setget __set
	var channel: GuildVoiceChannel setget __set, get_channel
	var user: User                 setget __set, get_user
	var member: Member             setget __set, get_member
	var session_id: String         setget __set
	var is_deafened: bool          setget __set
	var is_muted: bool             setget __set
	var self_deaf: bool            setget __set
	var self_mute: bool            setget __set
	var self_stream: bool          setget __set
	var self_video: bool           setget __set
	var suppress: bool             setget __set
	var request_to_speak: int      setget __set

	func _init(data: Dictionary).(data["user_id"]) -> void:
		guild_id = data["guild_id"]
		member = data.get("member")
		_update(data)

	func get_guild() -> Guild:
		return get_container().guilds.get(guild_id)

	func get_channel() -> GuildVoiceChannel:
		return self.guild.get_channel(channel_id) as GuildVoiceChannel
	
	func get_user() -> User:
		return get_container().users.get(self.id)

	func get_class() -> String:
		return "Guild.VoiceState"

	func get_member() -> Member:
		return member if member else self.guild.get_member(self.id) 

	func _update(data: Dictionary) -> void:
		channel_id = data.get("channel_id", channel_id)
		session_id = data.get("session_id", session_id)
		is_deafened = data.get("deaf", is_deafened)
		is_muted = data.get("mute", is_muted)
		self_deaf = data.get("self_deaf", self_deaf)
		self_mute = data.get("self_mute", self_mute)
		self_stream = data.get("self_stream", self_stream)
		self_video = data.get("self_video", self_video)
		suppress = data.get("suppress", suppress)
		request_to_speak = data.get("request_to_speak", request_to_speak)
	
	func _clone_data() -> Array:
		return [{
			user_id = self.id,
			guild_id = self.guild_id,
			member = member,
			channel_id = self.channel_id,
			session_id = self.session_id,
			is_deafened = self.is_deafened,
			is_muted = self.is_muted,
			self_deaf = self.self_deaf,
			self_mute = self.self_mute,
			self_stream = self.self_stream,
			self_video = self.self_video,
			suppress = self.suppress,
			request_to_speak = self.request_to_speak
		}]
	
	func __set(_value) -> void:
		pass

class Invite:
	
	enum TargetType {
		STREAM               = 1,
		EMBEDDED_APPLICATION = 2
	}
	
	var code: String                           setget __set
	var guild: Guild                           setget __set
	var channel: PartialChannel                setget __set
	var inviter: User                          setget __set
	var target_type: int                       setget __set
	var target_user: User                      setget __set
	var target_application: DiscordApplication setget __set
	var presence_count: int                    setget __set
	var member_count: int                      setget __set
	var expires_at: int                        setget __set
	var stage_instance: StageInstanceInvite    setget __set
	var scheduled_event: GuildScheduledEvent   setget __set
	
	func _init(data: Dictionary) -> void:
		code = data["code"]
		guild = data.get("guild")
		channel = data.get("channel")
		inviter = data.get("inviter")
		target_type = data.get("target_type", 0)
		target_user = data.get("target_user")
		target_application = data.get("target_application")
		presence_count = data.get("presence_count", 0)
		member_count = data.get("member_count", 0)
		expires_at = data.get("expires_at", 0)
		stage_instance = data.get("stage_instance")
		scheduled_event = data.get("scheduled_event")
	
	func get_class() -> String:
		return "Guild.Invite"
	
	func __set(_value) -> void:
		pass

class GuildScheduledEvent extends DiscordEntity:
	enum PrivacyLevel {
		GUILD_ONLY = 2
	}
	
	enum EntityType {
		STAGE_INSTANCE = 1,
		VOICE          = 2,
		EXTERNAL       = 3
	}
	
	enum EventStatus {
		SCHEDULED = 1,
		ACTIVE    = 2,
		COMPLETED = 3,
		CANCELED  = 4,
	}
	
	var guild_id: int       setget __set
	var channel_id: int     setget __set
	var creator_id: int     setget __set
	var name: String        setget __set
	var description: String setget __set
	var start_time: int     setget __set
	var end_time: int       setget __set
	var privacy_level: int  setget __set
	var status: int         setget __set
	var creator: User       setget __set
	var user_count: int     setget __set
	var entity_id: int      setget __set
	var entity_type: int    setget __set
	var entity_metadata: ScheduledEventMetadata setget __set
	
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		channel_id = data.get("channel_id", 0)
		creator_id = data.get("creator_id", 0)
		name = data["name"]
		description = data.get("description", "")
		start_time = data.get("start_time", 0)
		end_time = data.get("end_time", 0)
		privacy_level = data["privacy_level"]
		status = data["status"]
		creator = data.get("creator")
		entity_id = data.get("entity_id", 0)
		entity_type = data["entity_type"]
		entity_metadata = data.get("entity_metadata")
	
	func get_class() -> String:
		return "Guild.GuildScheduledEvent"
	
	func __set(_value) -> void:
		pass


class ScheduledEventMetadata:
	var location: String setget __set
	
	func _init(_location) -> void:
		location = _location
	
	func get_class() -> String:
		return "Guild.ScheduledEventMetadata"
	
	func __set(_value) -> void:
		pass
