class_name UnicodeEmoji extends Emoji

func _init(unicode: String).({id = 0, name = unicode}):
	pass

func equals(entity: DiscordEntity) -> bool:
	return .equals(entity) and name == entity.name

func url_encoded() -> String:
	return name.http_escape()

func get_class() -> String:
	return "UnicodeEmoji"
