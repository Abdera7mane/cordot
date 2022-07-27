class_name DiscordApplicationCommand extends DiscordEntity

enum Type {
	CHAT_INPUT = 1,
	USER       = 2,
	MESSAGE    = 3,
}

var type: int
var application_id: int
var guild_id: int
var guild: Guild:
	get = get_guild
var name: String
var description: String
var options: Array
var default_permission: bool
var version: int

func _init(data: Dictionary) -> void:
	super(data["id"])
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
