class_name ActivityParty

var id: String         setget __set
var size: PoolIntArray setget __set

func _init(data: Dictionary) -> void:
	id = data.get("id", "")
	size = data.get("size", [])

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	if not id.empty():
		data["id"] = id
	var party_size: Array = []
	if size.size() > 0:
		party_size[0] = size[0]
	if size.size() > 1:
		party_size[1] = size[1]
	data["size"] = party_size
	return data

func __set(_value) -> void:
	pass
