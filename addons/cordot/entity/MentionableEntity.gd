class_name MentionableEntity extends DiscordEntity

func _init(id: int).(id) -> void:
	pass

func get_mention() -> String:
	return ""

func get_class() -> String:
	return "MentionableEntity"

func _to_string() -> String:
	var mention: String = self.get_mention()
	return mention if not mention.empty() else ._to_string()
