class_name GuildEditData

# warning-ignore-all:return_value_discarded
# warning-ignore-all:incompatible_ternary

var _data: Dictionary:
	get = to_dict

func set_name(name: String) -> GuildEditData:
	_data["name"] = name.strip_edges()
	return self

func set_verification_level(level: int) -> GuildEditData:
	_data["verification_level"] = level
	return self

func set_default_message_notifications(level: int) -> GuildEditData:
	_data["default_message_notifications"] = level
	return self

func set_explicit_content_filter(level: int) -> GuildEditData:
	_data["explicit_content_filter"] = level
	return self

func set_afk_channel(id: int) -> GuildEditData:
	_data["afk_channel_id"] = str(id)
	return self

func set_afk_timeout(seconds: int) -> GuildEditData:
	_data["afk_timeout"] = seconds
	return self

func set_icon(image: Image) -> GuildEditData:
	_data["icon"] = Marshalls.raw_to_base64(image.get_data()) if image else null
	return self

func set_owner(id: int) -> GuildEditData:
	_data["owner_id"] = str(id)
	return self

func set_splash(image: Image) -> GuildEditData:
	_data["splash"] = Marshalls.raw_to_base64(image.get_data()) if image else null
	return self

func set_discovery_splash(image: Image) -> GuildEditData:
	_data["discovery_splash"] = Marshalls.raw_to_base64(image.get_data()) if image else null
	return self

func set_banner(image: Image) -> GuildEditData:
	_data["banner"] = Marshalls.raw_to_base64(image.get_data())
	return self

func set_system_channel(id: int) -> GuildEditData:
	_data["system_channel_id"] = str(id)
	return self

func set_system_channel_flags(flags: int) -> GuildEditData:
	_data["system_channel_flags"] = flags
	return self

func set_rules_channel(id: int) -> GuildEditData:
	_data["rules_channel_id"] = str(id)
	return self

func set_public_updates_channel(id: int) -> GuildEditData:
	_data["public_updates_channel_id"] = str(id)
	return self

func set_preferred_locale(local: String) -> GuildEditData:
	_data["preferred_locale"] = local
	return self

func set_features(features: PackedStringArray) -> GuildEditData:
	_data["features"] = features
	return self

func set_description(description: String) -> GuildEditData:
	_data["description"] = description
	return self

func enable_premium_progress_bar(value: bool) -> GuildEditData:
	_data["premium_progress_bar_enabled"] = value
	return self

func remove_afk_channel() -> GuildEditData:
	_data["afk_channel_id"] = null
	return self

func remove_system_channel() -> GuildEditData:
	_data["system_channel_id"] = null
	return self

func remove_rules_channel() -> GuildEditData:
	_data["rules_channel_id"] = null
	return self

func remove_public_updates_channel() -> GuildEditData:
	_data["public_updates_channel_id"] = null
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "GuildEditData"

func __set(_value) -> void:
	pass
