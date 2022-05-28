class_name MessageEmbed

enum Type {
	UNKNOWN,
	RICH,
	IMAGE,
	VIDEO,
	GIFV,
	ARTICLE,
	LINK
}

var title: String                    setget __set
var type: int                        setget __set
var description: String              setget __set
var url: String                      setget __set
var timestamp: int                   setget __set
var color: Color                     setget __set
var footer: MessageEmbedFooter       setget __set
var image: MessageEmbedImage         setget __set
var thumbnail: MessageEmbedThumbnail setget __set
var video: MessageEmbedVideo         setget __set
var provider: MessageEmbedProvider   setget __set
var author: MessageEmbedAuthor       setget __set
var fields: Array                    setget __set

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
