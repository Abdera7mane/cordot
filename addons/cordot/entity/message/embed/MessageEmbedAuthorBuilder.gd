class_name MessageEmbedAuthorBuilder

var _data: Dictionary setget __set

func _init(name: String) -> void:
	_data["name"] = name

func set_url(url: String) -> MessageEmbedAuthorBuilder:
	_data["url"] = url
	return self

func set_icon_url(icon_url: String) -> MessageEmbedAuthorBuilder:
	_data["icon_url"] = icon_url
	return self

func set_proxy_icon_url(proxy_icon_url: String) -> MessageEmbedAuthorBuilder:
	_data["proxy_icon_url"] = proxy_icon_url
	return self

func build() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "MessageEmbedAuthorBuilder"

func __set(_value) -> void:
	pass
