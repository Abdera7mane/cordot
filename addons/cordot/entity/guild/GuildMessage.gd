# Represents a message sent in a guild channel within Discord.
class_name GuildMessage extends Message

# The id of the guild.
var guild_id: int          setget __set

# The guild in which the message was sent.
var guild: Guild           setget __set, get_guild

# The guild member who sent the message.
var member: Guild.Member   setget __set

# List of `Guild.Role`s mentioned in the message.
var role_mentions: Array   setget __set

# Whether the message mentions everyone.
var mention_everyone: bool setget __set

# Whether the message is a TTS message.
var is_tts: bool           setget __set

# doc-hide
func _init(data: Dictionary).(data) -> void:
	guild_id = data["guild_id"]
	is_tts = data.get("tts", false)
	member = data["member"]

# `guild` getter.
func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

# doc-hide
func get_channel() -> TextChannel:
	var channel: Channel = self.guild.get_channel(channel_id)
	if not channel:
		channel = self.guild.get_thread(channel_id)
	if channel is Guild.GuildVoiceChannel:
		channel = channel.text_channel
	return channel as TextChannel

# Cross-post a message in a `Guild.GuildNewsChannel` to following channels.
# Requires the `SEND_MESSAGES` permission, if the current user sent the message,
# or additionally the `MANAGE_MESSAGES` permission, for all other users' messages.
#
# doc-qualifiers:coroutine
# doc-override-return:GuildMessage
func crosspost() -> GuildMessage:
	if self.channel.type != Channel.Type.GUILD_NEWS:
		push_error("Can not crosspost a message in a non-news channel")
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"crosspost_message", [channel_id, self.id]
	)

# doc-hide
func get_class() -> String:
	return "GuildMessage"

func _update(data: Dictionary) -> void:
	._update(data)
	role_mentions = data.get("role_mentions", role_mentions)
	role_mentions = data.get("role_mentions", role_mentions)
	mention_everyone = data.get("mention_everyone", mention_everyone)

func _clone_data() -> Array:
	var data: Array = ._clone_data()
	
	var arguments: Dictionary = data[0]
	arguments["guild_id"] = self.guild_id
	arguments["role_mentions"] = self.role_mentions.duplicate()
	arguments["channel_mentions"] = self.channel_mentions.duplicate()
	arguments["mention_everyone"] = self.mention_everyone
	arguments["is_tts"] = self.is_tts
	arguments["member"] = self.member
	
	return data

func __set(_value) -> void:
	pass
