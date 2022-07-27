class_name MessageEmbedFooter

var text: String      
var icon_url: String  
var proxy_url: String 

func _init(_text: String, _icon_url: String, _proxy_url: String) -> void:
	text = _text
	icon_url = _icon_url
	proxy_url = _proxy_url

func __set(_value) -> void:
	pass
