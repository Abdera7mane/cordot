class_name GuildMessage extends Message

var guild_id: int          setget __set
var guild: Guild           setget __set, get_guild
var member: Guild.Member   setget __set, get_member
var role_mentions: Array   setget __set
var mention_everyone: bool setget __set
var is_tts: bool           setget __set

func _init(data: Dictionary).(data) -> void:
	guild_id = data["guild_id"]
	is_tts = data.get("tts", false)

func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

func get_member() -> Guild.Member:
	return self.guild.get_member(author_id)

func crosspost() -> GuildMessage:
	if self.channel.type != Channel.Type.GUILD_NEWS:
		push_error("Can not crosspost a message in a non-news channel")
		return Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"crosspost_message", [channel_id, self.id]
	)

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
	
	return data

func __set(_value) -> void:
	pass
