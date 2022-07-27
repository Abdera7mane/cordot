class_name ChannelMention extends DiscordEntity

var guild_id: int
var guild: Guild:
	get = get_guild
var type: int
var name: String

func _init(id: int, _guild_id: int, _type: int, _name: String) -> void:
	super(id)
	guild_id = guild_id
	type = _type
	name = _name

func get_channel() -> Channel:
	return get_container().channels.get(self.id)

func get_guild() -> Guild:
	return null

func __set(_value) -> void:
	pass
