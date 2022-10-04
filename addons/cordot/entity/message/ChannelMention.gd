# Contains information on the mention channel in a message.
class_name ChannelMention extends DiscordEntity

# The id of the guild containing the channel.
var guild_id: int setget __set

# Reference to the guild containing the channel.
var guild: Guild  setget __set, get_guild

# The type of channel.
var type: int     setget __set

# The name of the channel.
var name: String  setget __set

# doc-hide
func _init(id: int, _guild_id: int, _type: int, _name: String).(id) -> void:
	guild_id = guild_id
	type = _type
	name = _name

# Gets the mentioned channel if it is available to the current user
# and found in the cache.
func get_channel() -> Channel:
	return get_container().channels.get(self.id)

# `guild` getter.
func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

func __set(_value) -> void:
	pass
