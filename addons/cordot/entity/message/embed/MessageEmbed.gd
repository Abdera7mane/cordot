# Represents an embeded content within a message.
class_name MessageEmbed

# Message embed types.
enum Type {
	UNKNOWN,
	RICH,
	IMAGE,
	VIDEO,
	GIFV,
	ARTICLE,
	LINK
}

# Title of embed.
var title: String                    setget __set

# Type of embed.
var type: int                        setget __set

# Description of embed
var description: String              setget __set

# Url of embed.
var url: String                      setget __set

# Unix timestamp of embed content.
var timestamp: int                   setget __set

# Color of embed.
var color: Color                     setget __set

# Footer information.
var footer: MessageEmbedFooter       setget __set

# Image information.
var image: MessageEmbedImage         setget __set

# Tumbnail information.
var thumbnail: MessageEmbedThumbnail setget __set

# Video information.
var video: MessageEmbedVideo         setget __set

# Provider information.
var provider: MessageEmbedProvider   setget __set

# Author information.
var author: MessageEmbedAuthor       setget __set

# List of `MessageEmbedField`s.
var fields: Array                    setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	title = data.get("title", "")
	type = data.get("type", Type.UNKNOWN)
	description = data.get("description", "")
	url = data.get("url", "")
	timestamp = data.get("timestamp", 0)
	color = data.get("color", Color())
	footer = data.get("footer")
	image = data.get("image")
	thumbnail = data.get("thumbnail")
	video = data.get("video")
	provider = data.get("provider")
	author = data.get("author")
	fields = data.get("fields", [])

func __set(_value) -> void:
	pass
