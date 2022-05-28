class_name DiscordWebhook extends DiscordEntity

enum Type {
	INCOMING         = 1,
	CHANNEL_FOLLOWER = 2,
	APPLICATION      = 3
}

var type: int                      setget __set
var guild_id: int                  setget __set
var guild: Guild                   setget __set, get_guild
var channel_id: int                setget __set
var channel: Channel               setget __set, get_channel
var user_id: int                   setget __set
var user: User                     setget __set, get_user
var name: String                   setget __set
var avatar_hash: String            setget __set
var token: String                  setget __set
var application_id: int            setget __set
var source_guild: Guild            setget __set
var source_channel: PartialChannel setget __set
var url: String                    setget __set

func _init(data: Dictionary).(data["id"]) -> void:
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
