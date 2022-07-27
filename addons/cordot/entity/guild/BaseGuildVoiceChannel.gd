class_name BaseGuildVoiceChannel extends VoiceChannel


var name: String
var guild_id: int
var guild: Guild:
	get = get_guild
var position: int
var parent_id: int
var parent: ChannelCategory:
	get = get_parent
var overwrites: Array

func _init(data: Dictionary) -> void:
	super(data)
	guild_id = data["guild_id"]

func get_guild() -> Guild:
	return Guild

func get_parent() -> ChannelCategory:
	return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null

func edit(data: GuildVoiceChannelEditData) -> BaseGuildVoiceChannel:
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
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_channel", [self.id, data.to_dict()]
	)

func get_class() -> String:
	return "Guild.BaseGuildVoiceChannel"

func _update(data: Dictionary) -> void:
	super(data)
	name = data.get("name", name)
	position = data.get("position", position)
	parent_id = data.get("parent_id", parent_id)
	overwrites = data.get("overwrites", overwrites)

func _clone_data() -> Array:
	var data: Array = super()

	var arguments: Dictionary = data[0]
	arguments["name"] = self.name
	arguments["guild_id"] = self.guild_id
	arguments["position"] = self.position
	arguments["parent_id"] = self.parent_id
	arguments["overwrites"] = self.overwrites.duplicate()

	return data

#	func __set(_value) -> void:
#		pass
