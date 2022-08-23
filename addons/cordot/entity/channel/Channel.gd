# Represents a guild or DM channel within Discord.
class_name Channel extends MentionableEntity

# Channel types.
enum Type {
	UNKNOWN = -1,
	GUILD_TEXT,
	DM,
	GUILD_VOICE,
	GROUP_DM,
	GUILD_CATEGORY,
	GUILD_NEWS,
	GUILD_STORE,
	GUILD_NEWS_THREAD    = 10,
	GUILD_PUBLIC_THREAD  = 11,
	GUILD_PRIVATE_THREAD = 12,
	GUILD_STAGE_VOICE    = 13
}

# The type of channel.
var type: int setget __set

# doc-hide
func _init(id: int).(id) -> void:
	pass

# Fetches the channel from Discord API.
#
# doc-qualifiers:coroutine
func fetch() -> Channel:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_channel",
		[self.id]
	)

# doc-hide
func get_mention() -> String:
	return "<#%d>" % self.id

# Gets the creation timestamp of the channel in unix time.
func get_creation_timestamp() -> int:
	return self.snowflake.get_timestamp()

# Whether the channel is part of a guild.
func is_guild() -> bool:
	return "guild_id" in self

# Whether the channel is a text channel.
func is_text() -> bool:
	return "last_message_id" in self

# Whether the channel is a voice channel.
func is_voice() -> bool:
	return "bitrate" in self

# doc-hide
func get_class() -> String:
	return "Channel"

func _update(_data: Dictionary) -> void:
	pass

func __set(_value) -> void:
	pass
