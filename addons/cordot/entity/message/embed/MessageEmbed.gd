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

var title: String                    
var type: int                        
var description: String              
var url: String                      
var timestamp: int                   
var color: Color                     
var footer: MessageEmbedFooter       
var image: MessageEmbedImage         
var thumbnail: MessageEmbedThumbnail 
var video: MessageEmbedVideo         
var provider: MessageEmbedProvider   
var author: MessageEmbedAuthor       
var fields: Array                    

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
