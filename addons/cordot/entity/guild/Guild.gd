# Represents a guild on Discord also known as a server. 
class_name Guild extends DiscordEntity

# Notification level options.
enum MessageNotificationLevel {
	ALL_MESSAGES,
	ONLY_MENTIONS
}

# Explicit content filter options.
enum ExplicitContentFilterLevel {
	DISABLED,
	MEMBERS_WITHOUT_ROLES,
	ALL_MEMBERS
}

# MFA level options.
enum MFALevel {
	NONE,
	ELEVATED
}

# Verification level options.
enum VerificationLevel {
	NONE,
	LOW,
	MEDIUM,
	HIGH,
	VERY_HIGH
}

# NSFW level options.
enum NSFWLevel {
	DEFAULT,
	EXPLICIT,
	SAFE,
	AGE_RESTRICTED
}

# Nitro boost tiers.
enum PremiumTier {
	NONE,
	TIER_1,
	TIER_2,
	TIER_3
}

# System channel flags.
enum SystemChannelFlags {
	SUPPRESS_JOIN_NOTIFICATIONS           = 1 << 0,
	SUPPRESS_PREMIUM_SUBSCRIPTIONS        = 1 << 1,
	SUPPRESS_GUILD_REMINDER_NOTIFICATIONS = 1 << 2
}

# Guild features.
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
var _stage_instances: Dictionary             setget __set
var _stickers: Dictionary                    setget __set
var _scheduled_events: Dictionary            setget __set

# Name of the guild.
var name: String                             setget __set

# Description of the guild.
var description: String                      setget __set

# The guild's owner id.
var owner_id: int                            setget __set

# Owner of the guild.
var owner: Member                            setget __set, get_owner

# Icon hash string. Empty if the guild has no icon.
var icon_hash: String                        setget __set

# Invite splash screen hash string.
# Empty if the guild has no Invite splash screen.
var splash_hash: String                      setget __set

# Discovery splash screen hash string.
# Empty if the guild has no Discovery splash screen.
var discovery_splash_hash: String            setget __set

# AFK voice channel id.
var afk_channel_id: int                      setget __set

# AFK voice channel.
var afk_channel: GuildVoiceChannel           setget __set, get_afk_channel

# Voice inactivity timeout in seconds.
var afk_timeout: int                         setget __set

# `true` if the server widget is enabled.
var widget_enabled: bool                     setget __set

# The channel id that the widget will generate an invite to,
# or `0` if set to no invite.
var widget_channel_id: int                   setget __set

# Reference to the widget channel.
var widget_channel: Channel                  setget __set, get_widget_channel

# The guild's `VerificationLevel`.
var verification_level: int                  setget __set

# The guild's default `MessageNotificationLevel`.
var default_message_notifications: int       setget __set

# The guild's `ExplicitContentFilterLevel`.
var explicit_content_filter: int             setget __set

# Roles in the guild.
var roles: Array                             setget __set, get_roles

# Custom emojis in the guild.
var emojis: Array                            setget __set, get_emojis

# Enabled guild `Features`.
var features: PoolIntArray                   setget __set

# The guild's `MFALevel`.
var mfa_level: int                           setget __set

# Application id of the guild creator if it is bot-created.
var application_id: int                      setget __set

# System channel id.
var system_channel_id: int                   setget __set

# System channel.
var system_channel: GuildTextChannel         setget __set, get_system_channel

# The guild's `SystemChannelFlags`.
var system_channel_flags: BitFlag            setget __set

# Rules channel id.
var rules_channel_id: int                    setget __set

# Rules channel.
var rules_channel: GuildTextChannel          setget __set, get_rules_channel

# `true` if this is considered a large guild.
var is_large: bool                           setget __set

# `true` if this guild is unavailable due to an outage.
var unavailable: bool                        setget __set

# Total number of members in this guild.
var member_count: int                        setget __set

# States of members currently in voice channels.
var voice_states: Dictionary                 setget __set

# Members of the guild. This does not include all members if the guild is large 
# or the members cache is disabled.  
# Use `member_count` to get the total number of members.  
# Use `get_member` to get a member by id from cache.  
# Use `fetch_member` to get a member by id.  
# Use `fetch_members` to get a chunk of the members list.
var members: Array                           setget __set, get_members

# List of channel ids in the guild.
var channels_ids: Array                      setget __set

# List of thread ids in the guild.
var threads_ids: Array                       setget __set

# Channels in the guild.
var channels: Array                          setget __set, get_channels

# The maximum number of presences for the guild,
# only set on the largest of guilds.
var max_presences: int                       setget __set

# The maximum number of members for the guild.
var max_members: int                         setget __set

# The vanity url code for the guild. Empty if the guild has no vanity url.
var vanity_url_code: String                  setget __set

# Banner hash string. Empty if the guild has no banner.
var banner_hash: String                      setget __set

# The guilds's `PremiumTier` (Server Boost level).
var premium_tier: int                        setget __set

# The number of boosts this guild currently has.
var premium_subscription_count: int          setget __set

# The preferred locale of a Community guild, defaults to `en-US`.
var preferred_locale: String                 setget __set

# The id of community updates channel.
var public_updates_channel_id: int           setget __set

# Community updates channel.
var public_updates_channel: GuildTextChannel setget __set, get_public_updates_channel

# The maximum amount of users in a video channel.
var max_video_channel_users: int             setget __set

var welcome_screen: WelcomeScreen            setget __set

# The guild's `NSFWFilterLevel`.
var nsfw_level: int                          setget __set

# All active threads in the guild that current user has permission to view.
var threads: Array                           setget __set, get_threads

# Stage instances in the guild.
var stage_instances: Array                   setget __set, get_stage_instances

# Custom stickers in the guild.
var stickers: Array                          setget __set, get_stickers

# The scheduled events in the guild.
var scheduled_events: Array                  setget __set, get_scheduled_events

# Whether the guild has the boost progress bar enabled
var progress_bar_enabled: bool               setget __set

# doc-hide
func _init(data: Dictionary).(data.id) -> void:
	system_channel_flags = BitFlag.new(SystemChannelFlags)
	_update(data)

# Checks whether the guild has the given `feature`.
func has_feature(feature: int) -> bool:
	return feature in self.features

# Gets a channel by `channel_id` that is part of the guild.
func get_channel(channel_id: int) -> Channel:
	var channel: Channel = self.get_container().channels.get(channel_id)
	if channel and channel.is_guild() and channel.guild.id == self.id:
		return channel
	return null

# `channels` getter. `sort` can be `true` to sort the channels by position.
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

# `afk_channel` getter.
func get_afk_channel() -> GuildVoiceChannel:
	return get_channel(afk_channel_id) as GuildVoiceChannel

# `widget_channel` getter.
func get_widget_channel() -> Channel:
	return get_channel(widget_channel_id)

# `system_channel` getter.
func get_system_channel() -> GuildTextChannel:
	return get_channel(system_channel_id) as GuildTextChannel

# `rules_channel` getter.
func get_rules_channel() -> GuildTextChannel:
	return get_channel(rules_channel_id) as GuildTextChannel

# `public_updates_channel` getter.
func get_public_updates_channel() -> GuildTextChannel:
	return get_channel(public_updates_channel_id) as GuildTextChannel

# Gets a member by `member_id` from cache.
func get_member(member_id: int) -> Member:
	return self._members.get(member_id)

# `members` getter (retrieves from cache).
func get_members() -> Array:
	return self._members.values()

# `owner` getter.
func get_owner() -> Member:
	return self.get_member(owner_id)

# `roles` getter.
func get_roles() -> Array:
	return self._roles.values()

# Gets a role by `role_id`.
func get_role(role_id: int) -> Role:
	return self._roles.get(role_id)

# Gets default role (`@everyone`).
func get_default_role() -> Role:
	return get_role(self.id)

# `emojis` getter.
func get_emojis() -> Array:
	return self._emojis.values()

# Get emoji by `emoji_id`.
func get_emoji(emoji_id: int) -> GuildEmoji:
	return self._emojis.get(emoji_id)

# `threads` getter.
func get_threads() -> Array:
	var _threads: Array = []
	for id in threads_ids:
		_threads.append(get_thread(id))
	return _threads

# Gets thread by `thread_id`.
func get_thread(thread_id: int) -> ThreadChannel:
	return get_channel(thread_id) as ThreadChannel

# `stage_instances` getter.	
func get_stage_instances() -> Array:
	return _stage_instances.values()

# Gets stage instance by `stage_id`.
func get_stage_instance(stage_id: int) -> StageInstance:
	return _stage_instances.get(stage_id)

# `stickers` getter.
func get_stickers() -> Array:
	return _stickers.values()

# Gets sticker by `sticker_id`.
func get_sticker(sticker_id: int) -> Object:
	return _stickers.get(sticker_id)

# `scheduled_events` getter.
func get_scheduled_events() -> Array:
	return _scheduled_events.values()

# Gets scheduled event by `event_id`.
func get_scheduled_event(event_id: int) -> GuildScheduledEvent:
	return _scheduled_events.get(event_id)

# Gets the guild's icon URL or an empty string if the guild has no icon.  
# `format` can be `jpg`, `jpeg`, `png`, `webp` or `gif`, defaults to `png`.  
# `size` is the image size and can be any power of two between `16` and `4096`
# (inclusive), defaults to `128`.
func get_icon_url(format: String = "png", size: int = 128) -> String:
	if not has_icon():
		return ""
	return Discord.CDN_URL + DiscordREST.ENDPOINTS.GUILD_ICON.format({
		"guild_id": self.id,
		"hash": icon_hash + "." + format + "?size=" + str(size)
	})

# Downloads the icon of the guild.
#
# doc-qualifiers:coroutine
# doc-override-return:Texture
func get_icon(format: String = "png", size: int = 128) -> Texture:
	if not has_icon():
		return Awaiter.submit()
	return yield(get_rest().cdn_download_async(
		get_icon_url(format, size))
	, "completed") as Texture

# Modify a guild's settings. Requires the `MANAGE_GUILD` permission.
func edit() -> GuildEditAction:
	return GuildEditAction.new(get_rest(), self.id)

# Deletes the guild permanently. User must be the owner.
# Returns `true` on success.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
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

# Fethes the guild.
#
# doc-qualifiers:coroutine
func fetch() -> Guild:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild", [self.id]
	)

# Fetches the guild channels from Discord API.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_channels() -> Array:
	return yield(get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_channels", [self.id]
	), "completed")

# Creates a new channel category in the guild.
func create_category() -> ChannelCategoryCreateAction:
	return ChannelCategoryCreateAction.new(get_rest(), self.id)

# Creates a new text channel in the guild.
func create_text_channel() -> TextChannelCreateAction:
	return TextChannelCreateAction.new(get_rest(), self.id)

# Creates a new text channel in the guild.
func create_voice_channel() -> VoiceChannelCreateAction:
	return VoiceChannelCreateAction.new(get_rest(), self.id)

# Edits channel positions.
func edit_channel_positions() -> ChannelEditPositionsAction:
	return ChannelEditPositionsAction.new(get_rest(), self.id)

# Fetches a guild member by `member_id` from Discord API.
#
# doc-qualifiers:coroutine
func fetch_member(member_id: int) -> Member:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_member", [self.id, member_id]
	)

# Fetches guild members from Discord API.
# `limit` is the maximum number of members to fetch with a maximum of `1000`.
# `after` is the id of the member to start fetching after.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_members(limit: int = 1, after: int = 0) -> Array:
	if limit < 1 or limit > 1000:
		push_error("fetch_member() 'limit' argument must be in range of 1 to 1000")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"list_guild_members", [self.id, limit, after]
	)

# Searches for guild members whose name starts with `query`.
# `limit` is the maximum number of members to fetch with a maximum of `1000`.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func search_members(query: String, limit: int = 1) -> Array:
	if limit < 1 or limit > 1000:
		push_error("search_members() 'limit' argument must be in range of 1 to 1000")
		yield(Awaiter.submit(), "completed")
		return []
	return get_rest().request_async(
		DiscordREST.GUILD,
		"search_guild_members", [self.id, query, limit]
	)

# Adds a member to the guild. Requires a valid oauth2 access token for the user
# with the `guilds.join` scope. Returns an array where the first element is 
# a boolean of whether the member was added and the second element is the member
# object.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func add_member(user_id: int, access_token: String) -> Array:
	# TODO add the rest of parameters of this endpoint
	return yield(get_rest().request_async(
		DiscordREST.GUILD,
		"add_guild_member", [self.id, user_id, {access_token = access_token}]
	), "completed")

# Edits the current member in the guild.
func edit_current_member() -> CurrentMemberEditAction:
	return CurrentMemberEditAction.new(get_rest(), self.id)

# Fetches the ban list of the guild. Returns an array of `GuildBan` objects.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
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

# Fetches the ban of a user from the guild. Returns a `GuildBan` object.
#
# doc-qualifiers:coroutine
# doc-override-return:GuildBan
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

# Fetches the roles of the guild.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_roles() -> Array:
	return yield(get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_roles", [self.id]
	), "completed")

# Creates a role in the guild.
func create_role() -> RoleCreateAction:
	return RoleCreateAction.new(get_rest(), self.id)

# Edits role positions in the guild.
# 
# doc-qualifiers:coroutine
# doc-override-return:Array
func edit_role_positions() -> RoleEditPositionsAction:
	return RoleEditPositionsAction.new(get_rest(), self.id)

# Fetches the prune count which indicates the number of members that would be 
# removed by a prune operation. Requires the `KICK_MEMBERS` permission.
#
# doc-qualifiers:coroutine
# doc-override-return:int
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

# Begin	pruning the guild. Requires the `KICK_MEMBERS` permission.
# For large guilds it's recommended to set the `return_count` option to `false`.
# Use `role_ids` to include members who have a subset of the roles specified.
# Returns the number of members that would be removed if `return_count` is `true`
# else `-1`.
#
# doc-qualifiers:coroutine
# doc-override-return:int
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

# Fetches the voice regions of the guild.
# Returns an array of `DiscordVoiceRegion` objects of VIP servers when the guild
# is VIP-enabled.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_voice_regions() -> Array:
	return yield(get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_voice_regions", [self.id]
	), "completed")

# Fetches the guild invites. Requires the `MANAGE_GUILD` permission.
# Returns an array of `Invite` objects.
#
# doc-qualifiers:coroutine
# doc-override-return:Array
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

# Returns a partial invite object for guilds with that feature enabled.
# Requires the `MANAGE_GUILD` permission.
# 
# doc-qualifiers:coroutine
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

# Fetches the guild's widget image.
# Use `style` to set the style of the widget image returned.
#
# Widget style options:
#
# - `shield`: shield style widget with Discord icon and guild members online
# count.
# - `banner1`: large image with guild icon, name and online count.
# "POWERED BY DISCORD" as the footer of the widget.
# - `banner2`: smaller widget style with guild icon, name and online count.
# Split on the right with Discord logo.
# - `banner3`: large image with guild icon, name and online count. In the footer,
# Discord logo on the left and "Chat Now" on the right.
# - `banner4`: large Discord logo at the top of the widget. Guild icon, name and
# online count in the middle portion of the widget and a "JOIN MY SERVER" button
# at the bottom.
#
# doc-qualifiers:coroutine
func fetch_widget_image(style: String = "shield") -> Texture:
	return get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild_widget_image", [self.id, style]
	)

# Checks if a member with the given `member_id` is inside the guild members cache.
func has_member(member_id: int) -> bool:
	return _members.has(member_id)

# Checks if the guild has an icon.
func has_icon() -> bool:
	return not icon_hash.empty()

# doc-hide
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

func __set(_value) -> void:
	pass

# Represents a member of a guild.
class Member extends MentionableEntity:
	
	# The user this guild member represents.
	var user: User          setget __set, get_user
	
	# The member's nickname. Equals to `user.username` if no nickname is set.
	var nickname: String    setget __set, get_nickname
	
	# the avatar hash of the member in the guild. Equals to `user.avatar_hash`
	# if the member has no avatar set on the guild.
	var avatar_hash: String setget __set, get_avatar_hash
	
	# Guild id of the member.
	var guild_id: int       setget __set
	# The guild this member is in.
	var guild: Guild        setget __set, get_guild
	
	# Assigned role ids of the member.
	var roles_ids: Array    setget __set
	
	# Assigned roles of the member.
	var roles: Array        setget __set, get_roles
	
	# The current presence state of the member.
	var presence: Presence  setget __set, get_presence
	
	# When the member joined the guild in unix timestamp (seconds).
	var join_date: int      setget __set
	
	# When the member started boosting the guild in unix timestamp (seconds).
	var premium_since: int  setget __set
	
	# Whether the user is deafened in voice channels.
	var is_deafened: bool   setget __set
	
	# Whether the user is muted in voice channels.
	var is_muted: bool      setget __set
	
	# Whether the user has not yet passed the guild's Membership Screening 
	# Requirements.
	var pending: bool       setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		join_date = data["join_date"]
		_update(data)
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# doc-hide
	func get_mention() -> String:
		return self.user.get_mention()
	
	# Deprecated. will be removed in the future.
	#
	# doc-deprecated
	func get_nickname_mention() -> String:
		return self.user.get_nickname_mention()
	
	# `nickname` getter.
	func get_nickname() -> String:
		return self.user.username if nickname.empty() else nickname
	
	# `avatar_hash` getter.
	func get_avatar_hash() -> String:
		return avatar_hash if not avatar_hash.empty() else self.user.avatar_hash
	
	# `roles` getter.
	func get_roles() -> Array:
		var _roles: Array
		for role_id in self.roles_ids:
			var role: Role = self.guild.get_role(role_id)
			if role:
				_roles.append(role)
		return _roles
	
	# `user` getter.
	func get_user() -> User:
		return self.get_container().users.get(self.id)
	
	# `presence` getter.
	func get_presence() -> Presence:
		return self.get_container().presences.get(self.id)
	
	# Gets a partial `VoiceState` object for the member.
	# Only contains `is_deafened` and `is_muted` properties.
	func get_partial_voice_state() -> VoiceState:
		var state: VoiceState = VoiceState.new({
			user_id = self.id,
			guild_id = guild_id,
			is_deafened = is_deafened,
			is_muted = is_muted
		})
		state.set_meta("partial", true)
		return state
	
	# Gets the member's voice state. If the member is not in a voice channel, 
	# returns a partial `VoiceState` object. See `get_partial_voice_state()`.
	func get_voice_state() -> VoiceState:
		if self.guild.voice_states.has(self.id):
			return guild.voice_states[self.id]
		return get_partial_voice_state()
	
	# Gets the member's permissions.
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
	
	# Gets the member's permissions in a specific channel.
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
	
	# Checks if the member is the guild owner.
	func is_owner() -> bool:
		return self.guild.owner_id == self.id
	
	# Checks if the member has the given `role_id`.
	func has_role(role_id: int) -> bool:
		return role_id in roles_ids
	
	# Modify attributes of a guild member.
	func edit() -> GuildMemberEditAction:
		return GuildMemberEditAction.new(get_rest(), guild_id, self.id)
	
	# Assigns a role to the member. Requires the `MANAGE_ROLES` permission.
	# Returns `true` on success.
	#
	# doc-qualifiers:coroutine
	# doc-override-return:bool
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
	
	# Revokes a role from the member. Requires the `MANAGE_ROLES` permission.
	# Returns `true` on success.
	#
	# doc-qualifiers:coroutine
	# doc-override-return:bool
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
	
	# Kicks the member from the guild. Requires the `KICK_MEMBERS` permission.
	# Returns `true` on success.
	#
	# doc-qualifiers:coroutine
	# doc-override-return:bool
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
	
	# Bans the member from the guild. Requires the `BAN_MEMBERS` permission.
	# Returns `true` on success.
	#
	# doc-qualifiers:coroutine
	# doc-override-return:bool
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
	
	# doc-hide
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
	
	# doc-hide
	func get_class() -> String:
		return "Widget"

# Represents a category channel on a guild. Holds a list of guild channels.
class ChannelCategory extends Channel:

	# Channel name.
	var name: String           setget __set

	# Guild id of the channel.
	var guild_id: int          setget __set

	# The Guild the channel is in.
	var guild: Guild           setget __set, get_guild

	# The channel position.
	var position: int          setget __set

	# Explicit permission overwrites for members and roles.
	var overwrites: Dictionary setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		_update(data)
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# Updates the category's settings. 
	func edit() -> ChannelCategoryEditAction:
		return ChannelCategoryEditAction.new(get_rest(), self.id)
	
	# doc-hide
	func get_class() -> String:
		return "Guild.ChannelCategory"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		name = data.get("name", name)
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

# Abstract base class for guild text channel.
class BaseGuildTextChannel extends TextChannel:
	
	# Channel name.
	var name: String             setget __set
	
	# Guild id of the channel.
	var guild_id: int            setget __set
	
	# The Guild the channel is in.
	var guild: Guild             setget __set, get_guild
	
	# The channel position.
	var position: int            setget __set
	
	# Amount of seconds a user has to wait before sending another message; 
	# bots, as well as users with the permission `MANAGE_MESSAGES or 
	# `MANAGE_CHANNELS` are unaffected.
	var rate_limit_per_user: int setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# doc-hide
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

# Represents a guild text channel.
class GuildTextChannel extends BaseGuildTextChannel:
	
	# Channel topic.
	var topic: String              setget __set
	
	# The parent category channel id. `0` if the channel is not in a category.
	var parent_id: int             setget __set
	
	# The parent category channel. `null` if the channel is not in a category.
	var parent: ChannelCategory    setget __set, get_parent
	
	# Explicit permission overwrites for members and roles.
	var overwrites: Dictionary     setget __set
	
	# Whether the channel is nsfw.
	var nsfw: bool                 setget __set
	
	# The default auto archive duration for newly created threads in this channel.
	var auto_archive_duration: int setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_TEXT
	
	# Checks if the channel has a parent (inside a category channel).
	func has_parent() -> bool:
		return get_parent() != null
	
	# `parent` getter.
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	# doc-hide
	func get_class() -> String:
		return "Guild.GuildTextChannel"
	
	# Update the hannel's settings.
	func edit() -> TextChannelEditAction:
		return TextChannelEditAction.new(get_rest(), self.id)
	
	func _update(data: Dictionary) -> void:
		._update(data)
		topic = data.get("topic", topic)
		parent_id = data.get("parent_id", parent_id)
		overwrites = data.get("overwrites", overwrites)
		nsfw = data.get("nsfw", nsfw)
		auto_archive_duration = data.get("auto_archive_duration", auto_archive_duration)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["topic"] = self.topic
		arguments["parent_id"] = self.parent_id
		arguments["overwrites"] = self.overwrites.duplicate()
		arguments["nsfw"] = self.nsfw
		arguments["auto_archive_duration"] = self.auto_archive_duration
		
		return data
	
	func __set(_value) -> void:
		pass

# Represents a guild news channel.
class GuildNewsChannel extends GuildTextChannel:
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_NEWS
	
	# doc-hide
	func get_class() -> String:
		return "Guild.GuildNewsChannel"

# Represents a thread channel.
class ThreadChannel extends BaseGuildTextChannel:
	
	# The owner id of the thread.
	var owner_id: int            setget __set
	
	# The owner of the thread.
	var owner: Member            setget __set, get_owner
	
	# The guild text channel id the thread was created in.
	var parent_id: int           setget __set
	
	# The guild text channel the thread was created in.
	var parent: GuildTextChannel setget __set, get_parent
	
	# An approximate count of messages in a thread.
	# If the thread was created before July 1, 2022, it stops counting at `50`.
	var message_count: int       setget __set
	
	# An approximate count of users in a thread, stops counting at `50`.
	var member_count: int        setget __set
	
	# Thread metadata.
	var metadata: ThreadMetaData setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		type = data["type"]
		owner_id = data["owner_id"]
		parent_id = data["parent_id"]
	
	# `owner` getter.
	func get_owner() -> Member:
		return self.guild.get_member(owner_id)
	
	# `parent` getter.
	func get_parent() -> GuildTextChannel:
		return self.guild.get_channel(parent_id) as GuildTextChannel
	
	# doc-hide
	func get_class() -> String:
		return "Guild.ThreadChannel"
	
	func _update(data: Dictionary) -> void:
		._update(data)
		message_count = data.get("message_count", message_count)
		member_count = data.get("member_count", member_count)
		metadata = data.get("metadata", metadata)
	
	func _clone_data() -> Array:
		var data: Array = ._clone_data()
		
		var arguments: Dictionary = data[0]
		arguments["owner_id"] = self.owner_id
		arguments["parent_id"] = self.parent_id
		arguments["message_count"] = self.message_count
		arguments["member_count"] = self.member_count
		arguments["metadata"] = self.metadata
		
		return data
	
	func __set(_value) -> void:
		pass

# Contains a number of thread-specific channel data.
class ThreadMetaData:
	
	# Whether the thread is archived
	var archived: bool             setget __set
	
	# The duration in minutes to automatically archive the thread after the
	# last activity.
	var auto_archive_duration: int setget __set
	
	# Unix timestamp when the thread's archive status was last changed, used for
	# calculating recent activity.
	var archive_timestamp: int     setget __set
	
	# Whether the thread is locked; when a thread is locked, only users with
	# `MANAGE_THREADS` can unarchive it.
	var locked: bool               setget __set
	
	# Whether non-moderators can add other non-moderators to a thread; only
	# available on private threads
	var invitable: bool            setget __set
	
	# Unix timestamp when the thread was created; only available for threads
	# created after January 9, 2022.
	var create_timestamp: int      setget __set
	
	# doc-hide
	func _init(data: Dictionary) -> void:
		_update(data)
	
	# Clones the thread metadata.
	func clone() -> ThreadMetaData:
		return get_script().new({
			archived = self.archived,
			auto_archive_duration = self.auto_archive_duration,
			archive_timestamp = self.archive_timestamp,
			locked = self.locked,
			invitable = self.invitable,
			create_timestamp = self.create_timestamp
		})
	
	# doc-hide
	func get_class() -> String:
		return "Guild.ThreadMetaData"
	
	func _update(data: Dictionary) -> void:
		archived = data.get("archived", archived)
		auto_archive_duration = data.get("auto_archive_duration", auto_archive_duration)
		archive_timestamp = data.get("archive_timestamp", archive_timestamp)
		locked = data.get("locked", locked)
		invitable = data.get("invitable", invitable)
		create_timestamp = data.get("create_timestamp", create_timestamp)
	
	func __set(_value) -> void:
		pass

# Represents a guild store channel.
class GuildStoreChannel extends Channel:
	
	# Channel name.
	var name: String            setget __set
	
	# Guild id of the channel.
	var guild_id: int            setget __set
	
	# The Guild the channel is in.
	var guild: Guild             setget __set, get_guild
	
	# Channel position.
	var position: int           setget __set
	
	# The parent category channel id. `0` if the channel is not in a category.
	var parent_id: int             setget __set
	
	# The parent category channel. `null` if the channel is not in a category.
	var parent: ChannelCategory    setget __set, get_parent
	
	# Explicit permission overwrites for members and roles.
	var overwrites: Dictionary  setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data["id"]) -> void:
		type = Channel.Type.GUILD_STORE
		guild_id = data["guild_id"]
		_update(data)
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# `parent` getter.
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	# doc-hide
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

# Abstract base class for voice guild channels.
class BaseGuildVoiceChannel extends VoiceChannel:
	
	# Channel name.
	var name: String                 setget __set
	
	# Guild id of the channel.
	var guild_id: int                setget __set
	
	# The Guild the channel is in.
	var guild: Guild                 setget __set, get_guild
	
	# Channel position.
	var position: int                setget __set
	
	# The parent category channel id. `0` if the channel is not in a category.
	var parent_id: int               setget __set
	
	# The parent category channel. `null` if the channel is not in a category.
	var parent: ChannelCategory      setget __set, get_parent
	
	# Explicit permission overwrites for members and roles.
	var overwrites: Array setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# `parent` getter.
	func get_parent() -> ChannelCategory:
		return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null
	
	# Update the channel's settings.
	func edit() -> VoiceChannelEditAction:
		return VoiceChannelEditAction.new(get_rest(), self.id)
	
	# doc-hide
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

# Represents a guild voice channel.
class GuildVoiceChannel extends BaseGuildVoiceChannel:
	
	# The user limit of the voice channel, `0` if unlimited.
	var user_limit: int              setget __set
	
	# The camera video quality mode of the voice channel, 
	# `VoiceChannel.VideoQualityModes.AUTO` when not present.
	var video_quality: int           setget __set
	
	# Reference to the textual chat in the voice channel.
	var text_channel: GuildVoiceText setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_VOICE
		text_channel = GuildVoiceText.new(data["text_channel"], self)
	
	# doc-hide
	func get_class() -> String:
		return "Guild.GuildVoiceChannel"
	
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

# Represents the textual chat in a guild voice channel.
# Unlike a guild text channel this does not accept threads or message pinning.
class GuildVoiceText extends TextChannel:
	
	var _parent: WeakRef          setget __set
	
	# The voice channel this chat belongs to.
	var parent: GuildVoiceChannel setget __set
	
	# doc-hide
	func _init(data: Dictionary, voice: GuildVoiceChannel).(data) -> void:
		_parent = weakref(voice)
	
	# `parent` getter.
	func get_parent() -> GuildVoiceChannel:
		return _parent.get_ref()
	
	# doc-hide
	func get_class() -> String:
		return "Guild.GuildVoiceText"
	
	func __set(_value) -> void:
		pass

# Represents a stage voice channel.
class StageChannel extends BaseGuildVoiceChannel:
	
	# The channel topic
	var topic: String           setget __set
	
	# Reference to the stage instance information.
	var instance: StageInstance setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		type = Channel.Type.GUILD_STAGE_VOICE
	
	# doc-hide
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

# Holds information about a live stage.
class StageInstance extends DiscordEntity:
	
	# Stage instance privacy level options.
	enum PrivacyLevel {
		PUBLIC,
		GUILD_ONLY
	}
	
	# Guild id of the stage instance.
	var guild_id: int         setget __set
	
	# The guild the stage is hosted.
	var guild: Guild          setget __set, get_guild
	
	# The stage channel id of the stage instance.
	var channel_id: int       setget __set
	
	# The stage channel where the stage is hosted.
	var channel: StageChannel setget __set, get_channel
	
	# Stage topic.
	var topic: String         setget __set
	
	# The privacy level of the Stage instance.
	var privacy_level: int    setget __set
	
	# doc-deprecated
	var discoverable: bool    setget __set
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# `channel` getter.
	func get_channel() -> StageChannel:
		var _channel: Channel = self.guild.get_channel(channel_id)
		if _channel is StageChannel:
			return _channel as StageChannel
		return null
	
	func __set(_value) -> void:
		pass

# Represents a set of permissions attached to a group of users.
class Role extends MentionableEntity:
	
	# Role name.
	var name: String         setget __set
	
	# Role color.
	var color: Color         setget __set
	
	# If this role is pinned in the user listing.
	var hoist: bool          setget __set
	
	# Role position.
	var position: int        setget __set
	
	# Permissions of the role.
	var permissions: BitFlag setget __set
	
	# Whether this role is managed by an integration.
	var is_managed: bool     setget __set
	
	# Whether this role is mentionable.
	var mentionable: bool    setget __set
	
	# The tags this role has.
	var tags: Tags           setget __set
	
	# Guild id of the role.
	var guild_id: int        setget __set
	
	# The guild the role is in.
	var guild: Guild         setget __set, get_guild
	
	# doc-hide
	func _init(data: Dictionary).(data["id"]) -> void:
		guild_id = data["guild_id"]
		permissions = BitFlag.new(Permissions.get_script_constant_map())
		_update(data)
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(guild_id)
	
	# doc-hide
	func get_mention() -> String:
		return "<@&%d>" % self.get_id()
	
	# Modify the role. Requires the `MANAGE_ROLES` permission.
	func edit() -> RoleEditAction:
		return RoleEditAction.new(get_rest(), guild_id, self.id)
	
	# Delete the role. Requires the `MANAGE_ROLES` permission.
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
	
	# doc-hide
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
		if color == Color.black:
			color = Color.transparent
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
		
		# doc-hide
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
		
		# doc-hide
		func get_class() -> String:
			return "Guild.Role.Tags"
		
		func _to_string() -> String:
			return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
		
		func __set(_value) -> void:
			pass

# Represents a custom guild emoji.
class GuildEmoji extends Emoji:
	
	# Guild id of the emoji.
	var guild_id: int     setget __set
	
	# The guild the emoji is from.
	var guild: Guild      setget __set, get_guild
	
	# Role ids of the roles that can use the emoji.
	var roles_ids: Array  setget __set
	
	# Roles allowed to use this emoji.
	var roles: Array      setget __set, get_roles
	
	# User id that created this emoji.
	var user_id: int      setget __set
	
	# The user that created this emoji.
	var user: User        setget __set, get_user
	
	# Whether this emoji is managed by an integration.
	var is_managed: bool  setget __set
	
	# Whether this emoji is animated.
	var is_animated: bool setget __set
	
	# Whether this emoji can be used, may be `false` due to loss of Server Boosts
	var available: bool   setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data) -> void:
		guild_id = data["guild_id"]
		user_id = data["user_id"]
		is_managed = data.get("is_managed", false)
		is_animated = data.get("is_animated", false)
		available = data.get("available", false)
	
	# doc-hide
	func get_mention() -> String:
		return ("<a:%s:%d>" if self.is_animated else "<:%s:%d>") % [self.name, self.id]
	
	# `guild` getter.
	func get_guild() -> Guild:
		return self.get_container().guilds.get(self.guild_id)
	
	# `roles` getter.
	func get_roles() -> Array:
		var _roles: Array
		for role_id in self.roles_ids:
			var role: Role = self.guild.get_role(role_id)
			if role:
				_roles.append(role)
		return _roles
	
	# `user` getter.
	func get_user() -> User:
		return self.get_container().users.get(self.user_id)
	
	# doc-hide
	func url_encoded() -> String:
		return ("a:%d" % self.id).percent_encode()
	
	# doc-hide
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

# Represents a user's voice connection status.
class VoiceState extends DiscordEntity:
	
	# Guild id of the voice state.
	var guild_id: int              setget __set
	
	# The guild the voice state is from.
	var guild: Guild               setget __set, get_guild
	
	# The voice channel id this user is connected to.
	var channel_id: int            setget __set
	
	# The voice channel this user is connected to.
	var channel: GuildVoiceChannel setget __set, get_channel
	
	# The user id this voice state is for.
	var user: User                 setget __set, get_user
	
	# The guild member this voice state is for.
	var member: Member             setget __set, get_member
	
	# The session id for this voice state.
	var session_id: String         setget __set
	
	# Whether this user is deafened by the server.
	var is_deafened: bool          setget __set
	
	# Whether this user is muted by the server.
	var is_muted: bool             setget __set
	
	# Whether this user is locally deafened.
	var self_deaf: bool            setget __set
	
	# Whether this user is locally muted.
	var self_mute: bool            setget __set
	
	# Whether this user is streaming.
	var self_stream: bool          setget __set
	
	# Whether this user's camera is enabled.
	var self_video: bool           setget __set
	
	# Whether this user is muted by the current user.
	var suppress: bool             setget __set
	
	# The unix time at which the user requested to speak.
	var request_to_speak: int      setget __set
	
	# doc-hide
	func _init(data: Dictionary).(data["user_id"]) -> void:
		guild_id = data["guild_id"]
		member = data.get("member")
		_update(data)
	
	# `guild` getter.
	func get_guild() -> Guild:
		return get_container().guilds.get(guild_id)
	
	# `channel` getter.
	func get_channel() -> GuildVoiceChannel:
		return self.guild.get_channel(channel_id) as GuildVoiceChannel
	
	# `user` getter.
	func get_user() -> User:
		return get_container().users.get(self.id)
	
	# `member` getter.
	func get_member() -> Member:
		return member if member else self.guild.get_member(self.id) 
	
	# doc-hide
	func get_class() -> String:
		return "Guild.VoiceState"
	
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

# Represents an invitation to a guild.
class Invite:
	
	# Invite target types.
	enum TargetType {
		STREAM               = 1,
		EMBEDDED_APPLICATION = 2
	}
	
	# the invite code (unique ID).
	var code: String                           setget __set
	
	# The guild this invite is for.
	var guild: Guild                           setget __set
	
	# The channel this invite is for.
	var channel: PartialChannel                setget __set
	
	# The user who created the invite.
	var inviter: User                          setget __set
	
	# The type of target for this voice channel invite.
	var target_type: int                       setget __set
	
	# The user whose stream to display for this voice channel stream invite.
	var target_user: User                      setget __set
	
	# The embedded application to open for this voice channel embedded
	# application invite.
	var target_application: DiscordApplication setget __set
	
	# Approximate count of online members.
	var presence_count: int                    setget __set
	
	# Approximate count of total members.
	var member_count: int                      setget __set
	
	# the expiration date of this invite.
	var expires_at: int                        setget __set
	
	# doc-deprecated
	var stage_instance: StageInstanceInvite    setget __set
	
	# Guild scheduled event data, only included if thee is a scheduled event in
	# the channel this invite is for.
	var scheduled_event: GuildScheduledEvent   setget __set
	
	# doc-hide
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
	
	# doc-hide
	func get_class() -> String:
		return "Guild.Invite"
	
	func __set(_value) -> void:
		pass

# Represents a scheduled event in a guild.
class GuildScheduledEvent extends DiscordEntity:
	
	# Event privacy levels.
	enum PrivacyLevel {
		GUILD_ONLY = 2
	}
	
	# Event entity types.
	enum EntityType {
		STAGE_INSTANCE = 1,
		VOICE          = 2,
		EXTERNAL       = 3
	}
	
	# Event status.
	enum EventStatus {
		SCHEDULED = 1,
		ACTIVE    = 2,
		COMPLETED = 3,
		CANCELED  = 4,
	}
	
	# The guild id which the scheduled event belongs to.
	var guild_id: int       setget __set
	
	# The channel id in which the scheduled event will be hosted,
	# or `0` if `entity_type` is `EntityType.EXTERNAL`.
	var channel_id: int     setget __set
	
	# The id of the user that created the scheduled event.
	var creator_id: int     setget __set
	
	# The user that created the scheduled event.
	var creator: User       setget __set
	
	# The name of the scheduled event.
	var name: String        setget __set
	
	# The description of the scheduled event.
	var description: String setget __set
	
	# The unix time the scheduled event will start
	var start_time: int     setget __set
	
	# The time the scheduled event will end,
	# required if `entity_type` is `EntityType.EXTERNAL`.
	var end_time: int       setget __set
	
	# The privacy level of the scheduled event.
	var privacy_level: int  setget __set
	
	# The status of the scheduled event.
	var status: int         setget __set
	
	# The number of users subscribed to the scheduled event.
	var user_count: int     setget __set
	
	# The id of an entity associated with a guild scheduled event.
	var entity_id: int      setget __set
	
	# The type of the scheduled event.
	var entity_type: int    setget __set
	
	# Additional metadata for the guild scheduled event.
	var entity_metadata: ScheduledEventMetadata setget __set
	
	# doc-hide
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
	
	# doc-hide
	func get_class() -> String:
		return "Guild.GuildScheduledEvent"
	
	func __set(_value) -> void:
		pass

# Contains additional information for a guild scheduled event.
class ScheduledEventMetadata:
	
	# Location of the event.
	var location: String setget __set
	
	# doc-hide
	func _init(_location) -> void:
		location = _location
	
	# doc-hide
	func get_class() -> String:
		return "Guild.ScheduledEventMetadata"
	
	func __set(_value) -> void:
		pass

