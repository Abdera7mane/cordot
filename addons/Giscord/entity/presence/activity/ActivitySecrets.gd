class_name ActivitySecrets

var join: String            setget __set
var spectate: String        setget __set
var instanced_match: String setget __set

func _init(data: Dictionary) -> void:
	join = data.get("join", "")
	spectate = data.get("spectate", "")
	instanced_match = data.get("instanced_match", "")

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	if not join.empty():
		data["join"] = join
	if not spectate.empty():
		data["spectate"] = spectate
	if not instanced_match.empty():
		data["instanced_match"] = instanced_match
	return data

func __set(_value) -> void:
	pass
