class_name MessageEmbedFooterBuilder

var _data: Dictionary setget __set

func _init(text: String) -> void:
	_data["text"] = text

func set_icon_url(icon_url: String) -> MessageEmbedFooterBuilder:
	_data["icon_url"] = icon_url
	return self

func set_proxy_icon_url(proxy_icon_url: String) -> MessageEmbedFooterBuilder:
	_data["proxy_icon_url"] = proxy_icon_url
	return self

func build() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "MessageEmbedFooterBuilder"

func __set(_value) -> void:
	pass
