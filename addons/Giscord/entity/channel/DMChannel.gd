class_name DMChannel extends PrivateChannel

func _init(data: Dictionary).(data) -> void:
	type = Type.DM

func get_recipient() -> User:
	return self.get_recipient_by_id(recipients_ids[0])

func get_class() -> String:
	return "DMChannel"

func __set(_value) -> void:
	pass
