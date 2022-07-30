class_name ChannelCategory extends Channel

var name: String
var guild_id: int
var guild: Guild:
	get: return get_container().guilds.get(guild_id)
var position: int
var overwrites: Dictionary

func _init(data: Dictionary) -> void:
	super(data["id"])
	guild_id = data["guild_id"]
	_update(data)

func edit(data: GuildChannelEditData) -> ChannelCategory:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).permissions_in(self.id)
	
	var fail: bool = false
	if not self_permissions.MANAGE_CHANNELS:
		push_error("Can not edit channel, missing MANAGE_CHANNELS permission")
		fail = true
	elif data.has("permission_overwrites") and not self_permissions.MANAGE_ROLES:
		push_error("Can not edit permission overwrites, missing MANAGE_ROLES permission")
		fail = true
	if fail:
		return await Awaiter.submit()
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_channel", [self.id, data.to_dict()]
	)

func get_class() -> String:
	return "ChannelCategory"

func _update(data: Dictionary) -> void:
	super(data)
	name = data.get("name", name)
	position = data.get("position", position)
	overwrites = data.get("overwrites", overwrites)

func _clone_data() -> Array:
	return [{
		id = self.id,
		name = self.name,
		guild_id = self.guild_id,
		position = self.position,
		overwrites = self.overwrites.duplicate()
	}]
