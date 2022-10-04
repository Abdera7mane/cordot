# Represents a message embed footer.
class_name MessageEmbedFooter

# The footer text.
var text: String      setget __set

# Url of footer icon.
var icon_url: String  setget __set

# A proxied url of footer icon
var proxy_url: String setget __set

# doc-hide
func _init(_text: String, _icon_url: String, _proxy_url: String) -> void:
	text = _text
	icon_url = _icon_url
	proxy_url = _proxy_url

func __set(_value) -> void:
	pass
