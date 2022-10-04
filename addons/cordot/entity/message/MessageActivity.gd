# Represents a Rich Presence activity chat embed.
class_name MessageActivity

# Message activity types.
enum Type {
	JOIN,
	SPECTATE,
	LISTEN,
	JOIN_REQUEST = 5
}

# Type of activity.
var type: int        setget __set

# Party id from a Rich Presence event.
var party_id: String setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	type = data["type"]
	party_id = data["party_id"]

# doc-hide
func get_class() -> String:
	return "MessageActivity"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
