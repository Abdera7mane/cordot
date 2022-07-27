class_name StageInstance extends DiscordEntity


enum PrivacyLevel {
	PUBLIC,
	GUILD_ONLY
}

var guild_id: int
var guild: Guild:
	get = get_guild
var channel_id: int
var channel: StageChannel:
	get = get_channel
var topic: String
var privacy_level: int
var discoverable: bool

func get_guild() -> Guild:
	return self.get_container().guilds.get(guild_id)

func get_channel() -> StageChannel:
	var _channel: Channel = self.guild.get_channel(channel_id)
	if _channel is StageChannel:
		return _channel as StageChannel
	return null

#	func __set(_value) -> void:
#		pass
