class_name GuildStoreChannel extends Channel

var name: String
var guild_id: int
var guild: Guild:
	get: return get_container().guilds.get(guild_id)
var position: int
var parent_id: int
var parent: ChannelCategory:
	get: return get_container().channels.get(parent_id)
var overwrites: Dictionary

func _init(data: Dictionary) -> void:
	super(data["id"])
	type = Channel.Type.GUILD_STORE
	guild_id = data["guild_id"]
	_update(data)

func get_class() -> String:
	return "Guild.GuildStoreChannel"

func _update(data: Dictionary) -> void:
	super(data)
	name = data.get("name", name)
	position = data.get("position", position)
	parent_id = data.get("parent_id", parent_id)
	overwrites = data.get("overwrites", overwrites)

func _clone_data() -> Array:
	return [{
		id = self.id,
		name = self.name,
		guild_id = self.guild_id,
		position = self.position,
		parent_id = self.parent_id,
		overwrites = self.overwrites.duplicate()
	}]
