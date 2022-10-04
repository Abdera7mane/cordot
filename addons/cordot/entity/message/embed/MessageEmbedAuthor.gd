# Contains information of the embed content author.
class_name MessageEmbedAuthor

# Name of author.
var name: String           setget __set

# Url of author.
var url: String            setget __set

# Url of author icon.
var icon_url: String       setget __set

# A proxied url of author icon.
var proxy_icon_url: String setget __set

# doc-hide
func _init(_name: String, _url: String, _icon_url: String, _proxy_icon_url: String) -> void:
	name = _name
	url = _url
	icon_url = _icon_url
	proxy_icon_url = _proxy_icon_url

func __set(_value) -> void:
	pass
