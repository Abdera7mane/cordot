class_name BaseGuildTextChannel extends TextChannel


var name: String
var guild_id: int
var guild: Guild: # Make this variable of type `Guild`
	get = get_guild
var position: int
var rate_limit_per_user: int

func _init(data: Dictionary) -> void:
	super(data)
	guild_id = data["guild_id"]

func get_guild() -> Guild:
	return self.get_container().guilds.get(guild_id)

func get_class() -> String:
	return "Guild.BaseGuildTextChannel"

func _update(data: Dictionary) -> void:
	super(data)
	name = data.get("name", name)
	position = data.get("position", position)
	rate_limit_per_user = data.get("rate_limit_per_user", rate_limit_per_user)

func _clone_data() -> Array:
	var data: Array = super()

	var arguments: Dictionary = data[0]
	arguments["name"] = self.name
	arguments["guild_id"] = self.guild_id
	arguments["position"] = self.position
	arguments["rate_limit_per_user"] = self.rate_limit_per_user

	return data

#	func __set(_value) -> void:
#		pass
