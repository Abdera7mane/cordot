# Presence update builder.
class_name PresenceUpdate

# warning-ignore-all:return_value_discarded

var _data: Dictionary = {
	since = null,
	activities = [],
	status = "online",
	afk = false
} setget __set, to_dict

# Sets the unix time (in milliseconds) of when the client went idle, or null
# if the client is not idle.
func since(unix_timestamp: int) -> PresenceUpdate:
	_data["since"] = unix_timestamp
	return self

# Adds an activity status.
func add_activity(activity: DiscordActivity) -> PresenceUpdate:
	_data["activities"].append(activity.to_dict())
	return self

# Sets the user status, status takes an `DiscordActivity.Type` enum value.
func set_status(status: int) -> PresenceUpdate:
	_data["status"] = Presence.status_to_string(status)
	return self

# Sets whether or not the client is afk.
func set_afk(afk: bool) -> PresenceUpdate:
	_data["afk"] = afk
	return self

# doc-hide
func to_dict() -> Dictionary:
	return _data.duplicate()

# doc-hide
func get_class() -> String:
	return "PresenceUpdate"

func __set(_value) -> void:
	pass
