class_name ActivityButton

var label: String 
var url: String   

func _init(data: Dictionary) -> void:
	label = data["label"]
	url = data["url"]

func __set(_value) -> void:
	pass
