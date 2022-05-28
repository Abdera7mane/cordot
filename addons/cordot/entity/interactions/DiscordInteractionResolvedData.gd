class_name DiscordInteractionResolvedData

var users: Dictionary       setget __set
var members: Dictionary     setget __set
var roles: Dictionary       setget __set
var channels: Dictionary    setget __set
var messages: Dictionary    setget __set
var attachments: Dictionary setget __set

func _init(data: Dictionary = {}) -> void:
	users = data.get("users", {})
	members = data.get("members", {})
	roles = data.get("roles", {})
	channels = data.get("channels", {})
	messages = data.get("messages", {})
	attachments = data.get("attachments", {})

func get_class() -> String:
	return "DiscordInteractionResolvedData"

func __set(_value) -> void:
	pass
