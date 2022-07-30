class_name StageInstance extends DiscordEntity

enum PrivacyLevel {
	PUBLIC,
	GUILD_ONLY
}

var guild_id: int
var guild: Guild:
	get: return get_container().guilds.get(guild_id)
var channel_id: int
var channel: StageChannel:
	get: return guild.get_channel(channel_id)
var topic: String
var privacy_level: int
var discoverable: bool
