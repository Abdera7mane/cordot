# Represents a unicode emoji. Requires Godot version >= 3.5.x to work properly.
# `name` will be equal to a unicode character.
class_name UnicodeEmoji extends Emoji

# doc-hide
func _init(unicode: String).({id = 0, name = unicode}):
	pass

# doc-hide
func equals(entity: DiscordEntity) -> bool:
	return .equals(entity) and name == entity.name

# doc-hide
func url_encoded() -> String:
	return name.percent_encode()

# doc-hide
func get_class() -> String:
	return "UnicodeEmoji"
