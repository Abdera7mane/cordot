# Helper class to build embed attachments.
class_name MessageEmbedAttachmentBuilder

var _data: Dictionary setget __set

# Constructs a new `MessageEmbedAttachmentBuilder` instance.
# `url` only supports http(s) and attachments based URL.
func _init(url: String) -> void:
	_data["url"] = url

# Sets the proxy URL.
func set_proxy_url(proxy_url: String) -> MessageEmbedAttachmentBuilder:
	_data["proxy_url"] = proxy_url
	return self

# Sets the image height.
func set_height(height: int) -> MessageEmbedAttachmentBuilder:
	_data["height"] = height
	return self

# Sets the image width.
func set_width(width: int) -> MessageEmbedAttachmentBuilder:
	_data["width"] = width
	return self

# Sets the image dimensions (width & height).
func set_size(size: Vector2) -> MessageEmbedAttachmentBuilder:
	return set_width(int(size.x)).set_height(int(size.y))

# Returns the embed attachment data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageEmbedAttachmentBuilder"

func __set(_value) -> void:
	pass
