class_name MessageEmbedAuthor

var name: String           setget __set
var url: String            setget __set
var icon_url: String       setget __set
var proxy_icon_url: String setget __set

func _init(_name: String, _url: String, _icon_url: String, _proxy_icon_url: String) -> void:
	name = _name
	url = _url
	icon_url = _icon_url
	proxy_icon_url = _proxy_icon_url

func __set(_value) -> void:
	pass
