class_name RoleCreateData

var _data: Dictionary

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

@warning_ignore(incompatible_ternary)
func set_icon(image: Image) -> RoleCreateData:
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
