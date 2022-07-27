class_name PresenceUpdate

# warning-ignore-all:return_value_discarded

var _data: Dictionary = {
	since = null,
	activities = [],
	status = "online",
	afk = false
} , to_dict

func since(unix_timestamp: int) -> PresenceUpdate:
	_data["since"] = unix_timestamp
	return self

func add_activity(activity: DiscordActivity) -> PresenceUpdate:
	_data["activities"].append(activity.to_dict())
	return self

func set_status(status: int) -> PresenceUpdate:
	_data["status"] = Presence.status_to_string(status)
	return self

func set_afk(afk: bool) -> PresenceUpdate:
	_data["afk"] = afk
	return self

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "PresenceUpdate"

func __set(_value) -> void:
	pass
