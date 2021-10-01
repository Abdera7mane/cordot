class_name Emoji extends MentionableEntity

var name: String setget __set

func _init(data: Dictionary).(data.id):
	name = data.name

func get_mention() -> String:
	return self.name

func get_class() -> String:
	return "Emoji"

func __set(_value) -> void:
	pass
