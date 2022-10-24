# Represents the resolved Discord entities objects
# in an application command interaction.
class_name DiscordApplicationCommandResolvedData

# Resolved users.
var users: Dictionary       setget __set

# Resolved members (can be partial).
var members: Dictionary     setget __set

# Resolved roles.
var roles: Dictionary       setget __set

# Resolved channels (can be partial).
var channels: Dictionary    setget __set

# Resolved messages (can be partial).
var messages: Dictionary    setget __set

# Resolved attachments.
var attachments: Dictionary setget __set

# doc-hide
func _init(data: Dictionary = {}) -> void:
	users = data.get("users", {})
	members = data.get("members", {})
	roles = data.get("roles", {})
	channels = data.get("channels", {})
	messages = data.get("messages", {})
	attachments = data.get("attachments", {})

# doc-hide
func get_class() -> String:
	return "DiscordApplicationCommandResolvedData"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
