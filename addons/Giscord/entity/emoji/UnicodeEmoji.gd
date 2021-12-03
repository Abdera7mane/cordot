class_name UnicodeEmoji extends Emoji

func _init(unicode: String).({id = 0, name = unicode}):
	pass

func url_encoded() -> String:
	return name.http_escape()

func get_class() -> String:
	return "UnicodeEmoji"
