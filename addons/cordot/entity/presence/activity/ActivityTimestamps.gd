class_name ActivityTimestamps

var start: int setget __set
var end: int   setget __set

func _init(data: Dictionary) -> void:
	start = data.get("start", 0)
	end = data.get("end", 0)

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	if start != 0:
		data["start"] = start
	if end != 0:
		data["end"] = end
	return data

func __set(_value) -> void:
	pass
