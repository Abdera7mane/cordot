class_name PrivateChannel extends TextChannel

var recipients_ids: Array setget __set
var recipients: Array     setget __set, get_recipients

func _init(data).(data) -> void:
	pass

func get_icon_async() -> ImageTexture:
	return null

func get_recipients() -> Array:
	var users: Array = []	
	for recipient_id in self.recipients_ids:
		var user: User = self.get_recipient_by_id(recipient_id)
		if user:
			users.append(user)
	return users

func has_recipient(id: int) -> bool:
	return id in self.recipients_ids

func get_recipient_by_id(id: int) -> User:
	return self.get_container().users.get(id) if self.has_recipient(id) else null

func get_class() -> String:
	return "PrivateChannel"

func _update(data: Dictionary) -> void:
	._update(data)
	recipients_ids = data.get("recipients_ids", recipients_ids)

func __set(_value) -> void:
	pass
