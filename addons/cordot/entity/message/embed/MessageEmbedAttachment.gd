# Represets an image or video attached with a message embed.
class_name MessageEmbedAttachment

# Source url of Attachment.
var url: String       setget __set

# A proxied url of the attachment.
var proxy_url: String setget __set

# Attachment dimensions.
var size: Vector2     setget __set

# doc-hide
func _init(_url: String, _proxy_url: String, _size: Vector2) -> void:
	url = _url
	proxy_url = _proxy_url
	size = _size

func __set(_value) -> void:
	pass
