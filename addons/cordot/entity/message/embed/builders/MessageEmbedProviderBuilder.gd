# Helper class to build message embed providers.
class_name MessageEmbedProviderBuilder

var _data: Dictionary setget __set

# Sets provider name.
func set_name(name: String) -> MessageEmbedProviderBuilder:
	_data["name"] = name
	return self

# Sets provider url.
func set_url(url: String) -> MessageEmbedProviderBuilder:
	_data["url"] = url
	return self

# Returns the embed provider data as a `Dictionary`.
func build() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "MessageEmbedProviderBuilder"

func __set(_value) -> void:
	pass
