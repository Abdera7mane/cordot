class_name RoleCreateData

# warning-ignore-all:return_value_discarded

var _data: Dictionary:
	get = to_dict

func set_name(name: String) -> RoleCreateData:
	_data["name"] = name
	return self

func set_permissions(flags: int) -> RoleCreateData:
	_data["permissions"] = flags
	return self

func set_color(color: Color) -> RoleCreateData:
	color.a = 0
	_data["color"] = color.to_argb32()
	return self

func set_hoist(value: bool) -> RoleCreateData:
	_data["set_hoist"] = value
	return self

func set_icon(image: Image) -> RoleCreateData:
	# warning-ignore:incompatible_ternary
	_data["icon"] = Marshalls.raw_to_base64(image.get_data()) if image else null
	return self

func set_unicode_emoji(unicode: String) -> RoleCreateData:
	_data["unicode_emoji"] = unicode
	return self

func mentionable(value: bool) -> RoleCreateData:
	_data["mentionable"] = value
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "RoleCreateData"

func __set(_value) -> void:
	pass
