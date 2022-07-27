class_name GroupDMEditData

# warning-ignore-all:return_value_discarded

var _data: Dictionary , to_dict

func set_name(name: String) -> GroupDMEditData:
	_data["name"] = name
	return self

func set_icon(image: Image) -> GroupDMEditData:
	# warning-ignore:incompatible_ternary
	_data["icon"] = Marshalls.raw_to_base64(image.get_data()) if image else null
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "GroupDMEditData"

func __set(_value) -> void:
	pass
