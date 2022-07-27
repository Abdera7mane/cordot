class_name MessageAttachment extends DiscordEntity

var filename: String
var description: String
var content_type: String
var size: int
var url: String
var proxy_url: String
var height: int
var width: int
var ephemeral: bool

func _init(data: Dictionary) -> void:
	super(data["id"])
	filename = data["filename"]
	description = data.get("description", "")
	content_type = data.get("content_type", "")
	size = data["size"]
	url = data["url"]
	proxy_url = data["proxy_url"]
	height = data.get("height", 0)
	width = data.get("width", 0)
	ephemeral = data.get("ephemeral", false)

#func __set(_value) -> void:
#	pass
