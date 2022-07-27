class_name UnicodeEmoji extends Emoji

func _init(unicode: String):
	super({id = 0, name = unicode})
	pass

func equals(entity: DiscordEntity) -> bool:
	return super(entity) and name == entity.name

func url_encoded() -> String:
	return name.percent_encode()

func get_class() -> String:
	return "UnicodeEmoji"
