class_name ActivityAssets

var large_image: String
var large_text: String
var small_image: String
var small_text: String

func _init(data: Dictionary) -> void:
	large_image = data.get("large_image", "")
	large_text = data.get("large_text", "")
	small_image = data.get("small_image", "")
	small_text = data.get("small_text", "")

func to_dict() -> Dictionary:
	var data: Dictionary = {}
	if not large_image.is_empty():
		data["large_image"] = large_image
	if not large_text.is_empty():
		data["large_text"] = large_text
	if not self.small_image.is_empty():
		data["small_image"] = small_image
	if not small_text.is_empty():
		data["small_text"] = small_text
	return data

#func __set(_value) -> void:
#	pass
