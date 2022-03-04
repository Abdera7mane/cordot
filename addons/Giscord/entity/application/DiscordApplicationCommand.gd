class_name DiscordApplicationCommand extends DiscordEntity

enum Type {
	CHAT_INPUT = 1,
	USER       = 2,
	MESSAGE    = 3,
}

var type: int                setget __set
var application_id: int      setget __set
var guild_id: int            setget __set
var guild: Guild             setget __set, get_guild
var name: String             setget __set
var description: String      setget __set
var options: Array           setget __set
var default_permission: bool setget __set
var version: int             setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	type = data.get("type", Type.CHAT_INPUT)
	application_id = data["application_id"]
	guild_id = data.get("guild_id", 0)
	name = data["name"]
	description = data["description"]
	options = data.get("options", [])
	default_permission = data.get("default_permission", true)
	version = data["version"]

func is_global() -> bool:
	return guild_id == 0

func get_guild() -> Guild:
	return get_container().guilds.get("guild_id")

func get_class() -> String:
	return "DiscordApplicationCommand"

func __set(_value) -> void:
	pass
