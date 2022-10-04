# Helper class to build message embed footers.
class_name MessageEmbedFooterBuilder

var _data: Dictionary setget __set

# Construct a new `MessageEmbedFooterBuilder` instance.
# `text` sets the footer's text.
func _init(text: String) -> void:
	_data["text"] = text

# Sets the footer's icon.
# `icon_url` only supports http(s) and attachments based URL.
func set_icon_url(icon_url: String) -> MessageEmbedFooterBuilder:
	_data["icon_url"] = icon_url
	return self

# Sets the footer's proxy icon url.
func set_proxy_icon_url(proxy_icon_url: String) -> MessageEmbedFooterBuilder:
	_data["proxy_icon_url"] = proxy_icon_url
	return self

# Returns the embed footer data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageEmbedFooterBuilder"

func __set(_value) -> void:
	pass
