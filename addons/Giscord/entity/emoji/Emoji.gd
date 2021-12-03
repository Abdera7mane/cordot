class_name Emoji extends MentionableEntity

var name: String setget __set

func _init(data: Dictionary).(data["id"]):
	name = data["name"]

func get_mention() -> String:
	return self.name

func get_class() -> String:
	return "Emoji"

func url_encoded() -> String:
	return ""

func to_dict() -> Dictionary:
	return {
		id = self.id,
		name = self.name
	}

func __set(_value) -> void:
	pass
