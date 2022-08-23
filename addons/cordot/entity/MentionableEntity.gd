# Represents a mentionable Discord object such as `User`s and `Channel`s.
class_name MentionableEntity extends DiscordEntity

# doc-hide
func _init(id: int).(id) -> void:
	pass

# Gets the mention tag.
func get_mention() -> String:
	return ""

# doc-hide
func get_class() -> String:
	return "MentionableEntity"

func _to_string() -> String:
	var mention: String = self.get_mention()
	return mention if not mention.empty() else ._to_string()
