class_name MessageReference

var message_id: int          setget __set
var channel_id: int          setget __set
var guild_id: int            setget __set
var fail_if_not_exists: bool setget __set

func _init(data: Dictionary) -> void:
	message_id = data.get("message_id", 0)
	channel_id = data.get("channel_id", 0)
	guild_id = data.get("guild_id", 0)
	fail_if_not_exists = data.get("fail_if_not_exists", true)

func get_class() -> String:
	return "MessageReference"

func __set(_value):
	pass
