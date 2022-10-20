# Action to edit a guild settings.
class_name GuildEditAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _data: Dictionary setget __set
var _reason: String   setget __set

# Constructs a new `GuildEditAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "edit_guild"

	_guild_id = guild_id

# Edits the guild settings.
#
# doc-qualifiers:coroutine
# doc-override-return:Guild
func submit():
	return _submit()

# Sets the guild name.
func set_name(name: String) -> GuildEditAction:
	_data["name"] = name.strip_edges()
	return self

# Sets the member verfication level.
# `level` takes a `Guild.VerificationLevel` value.
func set_verification_level(level: int) -> GuildEditAction:
	_data["verification_level"] = level
	return self

# Sets the default message notifications level.
# `level` takes a `Guild.MessageNotificationLevel` value.
func set_notifications_level(level: int) -> GuildEditAction:
	_data["default_message_notifications"] = level
	return self

# Sets the NSFW level.
# `level` takes a `Guild.ExplicitContentFilterLevel` value.
func set_nsfw_level(level: int) -> GuildEditAction:
	_data["explicit_content_filter"] = level
	return self

# Sets the afk channel in the guild.
# `id` must point to a voice channel.
func set_afk_channel(id: int) -> GuildEditAction:
	_data["afk_channel_id"] = str(id)
	return self

# Sets the afk timeout in seconds, can be set to: `60`, `300`, `900`, `1800` or `3600`.
func set_afk_timeout(seconds: int) -> GuildEditAction:
	_data["afk_timeout"] = seconds
	return self

# Sets the guild icon, `image` size has to be equal to `1024x1024`.
func set_icon(image: Image) -> GuildEditAction:
	_data["icon"] = image
	return self

# Transfers guild ownership to an other user.
# The user executing this must be the guild owner.
func set_owner(id: int) -> GuildEditAction:
	_data["owner_id"] = str(id)
	return self

# Sets the guild splash screen.
# Requires the guild to have `INVITE_SPLASH` feature.
func set_splash(image: Image) -> GuildEditAction:
	_data["splash"] = image
	return self

# Sets the guild discovery splash image.
# Requires the guild to have `DISCOVERABLE` feature.
func set_discovery_splash(image: Image) -> GuildEditAction:
	_data["discovery_splash"] = image
	return self

# Sets the guild banner image.
# Requires the guild to have `BANNER` feature.
func set_banner(image: Image) -> GuildEditAction:
	_data["banner"] = image
	return self

# Sets the system channel in the guild.
# `id` must point to a text channel.
func set_system_channel(id: int) -> GuildEditAction:
	_data["system_channel_id"] = str(id)
	return self

# Sets the system channel flags in the guild.
func set_system_channel_flags(flags: int) -> GuildEditAction:
	_data["system_channel_flags"] = flags
	return self

# Sets the afk channel in the guild.
# `id` must point to a text channel.
func set_rules_channel(id: int) -> GuildEditAction:
	_data["rules_channel_id"] = str(id)
	return self

# Sets the afk channel in the guild.
# `id` must point to a text channel.
func set_public_updates_channel(id: int) -> GuildEditAction:
	_data["public_updates_channel_id"] = str(id)
	return self

# Sets the preferred locale of a community guild.
# See [Locales](https://discord.com/developers/docs/reference#locales).
func set_preferred_locale(local: String) -> GuildEditAction:
	_data["preferred_locale"] = local
	return self

# Sets the enabled guild features.
func set_features(features: PoolStringArray) -> GuildEditAction:
	_data["features"] = features
	return self

# Sets the guild description.
func set_description(description: String) -> GuildEditAction:
	_data["description"] = description
	return self

# Whether the guild's boost progress bar should be enabled.
func enable_premium_progress_bar(value: bool) -> GuildEditAction:
	_data["premium_progress_bar_enabled"] = value
	return self

# Removes the afk channel.  
# **Note:** does not delete the channel.
func remove_afk_channel() -> GuildEditAction:
	_data["afk_channel_id"] = null
	return self

# Removes the system channel.  
# **Note:** does not delete the channel.
func remove_system_channel() -> GuildEditAction:
	_data["system_channel_id"] = null
	return self

# Removes the rules channel.  
# **Note:** does not delete the channel.
func remove_rules_channel() -> GuildEditAction:
	_data["rules_channel_id"] = null
	return self

# Removes the public updates channel.  
# **Note:** does not delete the channel.
func remove_public_updates_channel() -> GuildEditAction:
	_data["public_updates_channel_id"] = null
	return self

# Sets the reason for editing the guild.
func reason(why: String) -> GuildEditAction:
	_reason = why
	return self

# doc-hide
func get_class() -> String:
	return "GuildEditAction"

func _get_arguments() -> Array:
	var data: Dictionary = _data.duplicate()
	for key in ["icon", "splash", "discovery_splash", "banner"]:
		var value: Image = data.get(key)
		if value:
			data[key] = Marshalls.raw_to_base64(value.get_data())
	return [_guild_id, data, _reason]

func __set(_value) -> void:
	pass

