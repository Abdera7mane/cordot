class_name DiscordInteractionResolvedData

var users: Dictionary       
var members: Dictionary     
var roles: Dictionary       
var channels: Dictionary    
var messages: Dictionary    
var attachments: Dictionary 

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
