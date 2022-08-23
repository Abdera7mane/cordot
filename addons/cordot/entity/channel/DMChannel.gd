# Represents a direct message channel between two users.
class_name DMChannel extends PrivateChannel

# doc-hide
func _init(data: Dictionary).(data) -> void:
	type = Type.DM

# Gets the recipient of the DM channel.
func get_recipient() -> User:
	return self.get_recipient_by_id(recipients_ids[0])

# doc-hide
func get_class() -> String:
	return "DMChannel"

func __set(_value) -> void:
	pass
