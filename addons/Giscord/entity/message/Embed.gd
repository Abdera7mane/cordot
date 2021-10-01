class_name Embed

var title: String             setget __set
var type: String              setget __set
var description: String       setget __set
var url: String               setget __set
var timestamp: int            setget __set
var color: Color              setget __set
var footer: EmbedFooter       setget __set
var image: EmbedImage         setget __set
var thumbnail: EmbedThumbnail setget __set
var video: EmbedVideo         setget __set
var provider: EmbedProvider   setget __set
var author: EmbedAuthor       setget __set
var fields: Array             setget __set

func _init(data: Dictionary) -> void:
	self.title = data.get("title", "")
	self.type = data.get("type", "Uknown")
	self.description = data.get("description", "")
	self.url = data.get("url", "")
	self.timestamp = GDUtil.iso_to_unix_timestamp(data["timestamp"]) if data.has("timestamp") else -1
	self.color = Color(data.get("color", 0) as int)
	if (data.has("footer")):
		footer = EmbedFooter.new(
			data["footer"]["text"],
			data["footer"].get("icon_url", ""),
			data["footer"].get("proxy_icon_url", "")
		)
	if (data.has("thumbnail")):
		thumbnail = EmbedThumbnail.new(
			data["thumbnail"].get("url", ""),
			data["thumbnail"].get("proxy_url", ""),
			data["thumbnail"].get("height", 0),
			data["thumbnail"].get("width", 0)
		)
	if (data.has("video")):
		video = EmbedVideo.new(
			data["video"].get("url", ""),
			data["video"].get("height", 0),
			data["video"].get("width", 0)
		)
	if (data.has("image")):
		image = EmbedImage.new(
			data["image"].get("url", ""),
			data["image"].get("proxy_url", ""),
			data["image"].get("height", 0),
			data["image"].get("width", 0)
		)
	if (data.has("provider")):
		provider = EmbedProvider.new(
			data["provider"].get("name", ""),
			data["provider"].get("url", "")
		)
	if (data.has("author")):
		author = EmbedAuthor.new(
			data["author"].get("name", ""),
			data["author"].get("url", ""),
			data["author"].get("icon_url", ""),
			data["author"].get("proxy_icon_url", "")
		)
	for field_data in data.get("fields", []):
		fields.append(EmbedField.new(
			field_data["name"],
			field_data["value"],
			field_data.get("inline", false)
		))

func __set(_value) -> void:
	pass

class EmbedThumbnail:
	var url: String       setget __set
	var proxy_url: String setget __set
	var height: int       setget __set
	var width: int        setget __set
	
	func _init(_url: String, _proxy_url: String, _height: int, _width: int) -> void:
		url = _url
		proxy_url = _proxy_url
		height = _height
		width = _width

	func __set(_value) -> void:
		pass

class EmbedVideo:
	var url: String setget __set
	var height: int setget __set
	var width: int  setget __set
	
	func _init(_url: String, _height: int, _width: int) -> void:
		url = _url
		height = _height
		width = _width
	
	func __set(_value) -> void:
		pass

class EmbedImage:
	var url: String       setget __set
	var proxy_url: String setget __set
	var height: int       setget __set
	var width: int        setget __set
	
	func _init(_url: String, _proxy_url: String, _height: int, _width: int) -> void:
		url = _url
		proxy_url = _proxy_url
		height = _height
		width = _width
	
	func __set(_value) -> void:
		pass

class EmbedProvider:
	var name: String setget __set
	var url: String  setget __set
	
	func _init(_name: String, _url: String) -> void:
		name = _name
		url = _url
	
	func __set(_value) -> void:
		pass

class EmbedAuthor:
	var name: String           setget __set
	var url: String            setget __set
	var icon_url: String       setget __set
	var proxy_icon_url: String setget __set

	func _init(_name: String, _url: String, _icon_url: String, _proxy_icon_url: String) -> void:
		name = _name
		url = _url
		icon_url = _icon_url
		proxy_icon_url = _proxy_icon_url
	
	func __set(_value) -> void:
		pass

class EmbedFooter:
	var text: String      setget __set
	var icon_url: String  setget __set
	var proxy_url: String setget __set
	
	func _init(_text: String, _icon_url: String, _proxy_url: String) -> void:
		text = _text
		icon_url = _icon_url
		proxy_url = _proxy_url
	
	func __set(_value) -> void:
		pass

class EmbedField:
	var name: String  setget __set
	var value: String setget __set
	var inline: bool  setget __set
	
	func _init(_name: String, _value: String, _inline: bool) -> void:
		self.name = _name
		self.value = _value
		self.inline = _inline
	
	func __set(_value) -> void:
		pass
