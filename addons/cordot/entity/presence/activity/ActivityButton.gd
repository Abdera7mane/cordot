class_name ActivityButton

var label: String setget __set
var url: String   setget __set

func _init(data: Dictionary) -> void:
	label = data["label"]
	url = data["url"]

func __set(_value) -> void:
	pass
