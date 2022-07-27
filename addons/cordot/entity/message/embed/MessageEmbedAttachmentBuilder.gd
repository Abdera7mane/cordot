class_name MessageEmbedAttachmentBuilder

var _data: Dictionary 

func _init(url: String) -> void:
	_data["url"] = url

func set_proxy_url(proxy_url: String) -> MessageEmbedAttachmentBuilder:
	_data["proxy_url"] = proxy_url
	return self

func set_height(height: int) -> MessageEmbedAttachmentBuilder:
	_data["height"] = height
	return self

func set_width(width: int) -> MessageEmbedAttachmentBuilder:
	_data["width"] = width
	return self

func set_size(size: Vector2) -> MessageEmbedAttachmentBuilder:
	return set_width(int(size.x)).set_height(int(size.y))

func build() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "MessageEmbedAttachmentBuilder"

func __set(_value) -> void:
	pass
