# Contains information on the referenced message such in replies and cross posts.
class_name MessageReference

# The id of the originating message.
var message_id: int          setget __set

# The id of the originating message's channel.
var channel_id: int          setget __set

# The id of the originating message's guild.
var guild_id: int            setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	message_id = data.get("message_id", 0)
	channel_id = data.get("channel_id", 0)
	guild_id = data.get("guild_id", 0)

# doc-hide
func get_class() -> String:
	return "MessageReference"

func __set(_value):
	pass
