class_name MessageAttachment extends DiscordEntity

var filename: String     setget __set
var description: String  setget __set
var content_type: String setget __set
var size: int            setget __set
var url: String          setget __set
var proxy_url: String    setget __set
var height: int          setget __set
var width: int           setget __set
var ephemeral: bool      setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	filename = data["filename"]
	description = data.get("description", "")
	content_type = data.get("content_type", "")
	size = data["size"]
	url = data["url"]
	proxy_url = data["proxy_url"]
	height = data.get("height", 0)
	width = data.get("width", 0)
	ephemeral = data.get("ephemeral", false)

func __set(_value) -> void:
	pass
