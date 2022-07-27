class_name ActivitySecrets

var join: String
var spectate: String
var instanced_match: String

func _init(data: Dictionary) -> void:
	join = data.get("join", "")
	spectate = data.get("spectate", "")
	instanced_match = data.get("instanced_match", "")

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	if not join.is_empty():
		data["join"] = join
	if not spectate.is_empty():
		data["spectate"] = spectate
	if not instanced_match.is_empty():
		data["instanced_match"] = instanced_match
	return data

#func __set(_value) -> void:
#	pass
