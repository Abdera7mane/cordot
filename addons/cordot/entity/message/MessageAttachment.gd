# Represents a resource such as a file or image attached to a message.
class_name MessageAttachment extends DiscordEntity

# Name of the attached file.
var filename: String     setget __set

# Description for the file.
var description: String  setget __set

# The attachment's [media type](https://en.wikipedia.org/wiki/Media_type).
var content_type: String setget __set

# Size of file in bytes.
var size: int            setget __set

# Source url of file.
var url: String          setget __set

# A proxied url of file.
var proxy_url: String    setget __set

# Height of file (if image).
var height: int          setget __set

# Width of file (if image).
var width: int           setget __set

# Whether this attachment is ephemeral.
var ephemeral: bool      setget __set

# doc-hide
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
