class_name MessageEmbedProviderBuilder

var _data: Dictionary setget __set

func set_name(name: String) -> MessageEmbedProviderBuilder:
	_data["name"] = name
	return self

func set_url(url: String) -> MessageEmbedProviderBuilder:
	_data["url"] = url
	return self

func build() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "MessageEmbedProviderBuilder"

func __set(_value) -> void:
	pass
