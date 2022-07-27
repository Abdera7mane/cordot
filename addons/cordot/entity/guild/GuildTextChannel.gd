class_name GuildTextChannel extends BaseGuildTextChannel
var topic: String
var parent_id: int
var parent: ChannelCategory: # Make this variable of type `ChannelCategory`
	get = get_parent
var overwrites: Dictionary
var nsfw: bool
var auto_archive_duration: int

func _init(data: Dictionary) -> void:
	super(data)
	type = Channel.Type.GUILD_TEXT

func has_parent() -> bool:
	return get_parent() != null

func get_parent() -> ChannelCategory:
	return self.get_container().channels.get(self.parent_id) if self.parent_id != 0 else null

func get_class() -> String:
	return "Guild.GuildTextChannel"

func edit(data: GuildTextChannelEditData) -> GuildTextChannel:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).permissions_in(self.id)

	var fail: bool = false
	if not self_permissions.MANAGE_CHANNELS:
		fail = true
		push_error("Can not edit channel, missing MANAGE_CHANNELS permission")
	elif data.has("permission_overwrites") and not self_permissions.MANAGE_ROLES:
		fail = true
		push_error("Can not edit permission overwrites, missing MANAGE_ROLES permission")
	elif data.has("type") and not self.guild.has_feature(Features.NEWS):
		fail = true
		push_error("Can not convert to news channel, guild is missing NEWS feature")
	if fail:
		return await Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_channel", [self.id, data.to_dict()]
	)

func _update(data: Dictionary) -> void:
	super(data)
	topic = data.get("topic", topic)
	parent_id = data.get("parent_id", parent_id)
	overwrites = data.get("overwrites", overwrites)
	nsfw = data.get("nsfw", nsfw)
	auto_archive_duration = data.get("auto_archive_duration", auto_archive_duration)

func _clone_data() -> Array:
	var data: Array = super()

	var arguments: Dictionary = data[0]
	arguments["topic"] = self.topic
	arguments["parent_id"] = self.parent_id
	arguments["overwrites"] = self.overwrites.duplicate()
	arguments["nsfw"] = self.nsfw
	arguments["auto_archive_duration"] = self.auto_archive_duration

	return data

#	func __set(_value) -> void:
#		pass
