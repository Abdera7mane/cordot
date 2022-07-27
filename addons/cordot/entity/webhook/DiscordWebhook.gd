class_name DiscordWebhook extends DiscordEntity

enum Type {
	INCOMING         = 1,
	CHANNEL_FOLLOWER = 2,
	APPLICATION      = 3
}

var type: int
var guild_id: int
var guild: Guild:
	get = get_guild
var channel_id: int
var channel: Channel:
	get = get_channel
var user_id: int
var user: User:
	get = get_user
var name: String
var avatar_hash: String
var token: String
var application_id: int
var source_guild: Guild
var source_channel: PartialChannel
var url: String

func _init(data: Dictionary) -> void:
	super(data["id"])
	type = data["type"]
	guild_id = data.get("guild_id", 0)
	channel_id = data.get("channel_id", 0)
	user_id = data.get("user_id", 0)
	name = data.get("name", "")
	avatar_hash = data.get("avatar_hash", "")
	token = data.get("token", "")
	application_id = data.get("application_id", 0)
	source_guild = data.get("source_guild")
	source_channel = data.get("source_channel")
	url = data.get("url", "")

func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

func get_channel() -> Channel:
	return get_container().channels.get(channel_id)

func get_user() -> User:
	return get_container().users.get(user_id)

func __set(_value) -> void:
	pass
