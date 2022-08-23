# Abstract Discord emoji.
class_name Emoji extends MentionableEntity

# Emoji name.__set
var name: String setget __set

# doc-hide
func _init(data: Dictionary).(data["id"]):
	name = data["name"]

# doc-hide
func get_mention() -> String:
	return self.name

# doc-hide
func get_class() -> String:
	return "Emoji"

# Percent encode the emoji.
func url_encoded() -> String:
	return ""

# doc-hide
func to_dict() -> Dictionary:
	return {
		id = self.id,
		name = self.name
	}

func __set(_value) -> void:
	pass
