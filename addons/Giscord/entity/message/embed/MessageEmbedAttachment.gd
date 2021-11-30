class_name MessageEmbedAttachment

var url: String       setget __set
var proxy_url: String setget __set
var size: Vector2     setget __set

func _init(_url: String, _proxy_url: String, _size: Vector2) -> void:
	url = _url
	proxy_url = _proxy_url
	size = _size

func __set(_value) -> void:
	pass
