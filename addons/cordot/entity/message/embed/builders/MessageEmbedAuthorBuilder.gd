# Helper class to build embed author information.
class_name MessageEmbedAuthorBuilder

var _data: Dictionary setget __set

# Constructs a new `MessageEmbedAuthorBuilder` instance.
# `name` sets the author's name.
func _init(name: String) -> void:
	_data["name"] = name

# Sets a url link to the author.
func set_url(url: String) -> MessageEmbedAuthorBuilder:
	_data["url"] = url
	return self

# Sets the author's icon.
# `icon_url` only supports http(s) and attachments based URL.
func set_icon_url(icon_url: String) -> MessageEmbedAuthorBuilder:
	_data["icon_url"] = icon_url
	return self

# Sets the author's icon proxy url.
func set_proxy_icon_url(proxy_icon_url: String) -> MessageEmbedAuthorBuilder:
	_data["proxy_icon_url"] = proxy_icon_url
	return self

# Returns the embed author data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageEmbedAuthorBuilder"

func __set(_value) -> void:
	pass
