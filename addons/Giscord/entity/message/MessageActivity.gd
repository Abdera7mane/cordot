class_name MessageActivity

enum Type {
	JOIN,
	SPECTATE,
	LISTEN,
	JOIN_REQUEST = 5
}

var type: int        setget __set
var party_id: String setget __set

func _init(data: Dictionary) -> void:
	type = data["type"]
	party_id = data["party_id"]

func get_class() -> String:
	return "MessageActivity"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	pass
