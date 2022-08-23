# Represents a private channel on Discord.
class_name PrivateChannel extends TextChannel

# The recipient ids of the private channel.
var recipients_ids: Array setget __set

# The recipients of the private channel. Contains a list of User objects.
var recipients: Array     setget __set, get_recipients

# doc-hide
func _init(data).(data) -> void:
	pass

# `recipients` getter.
func get_recipients() -> Array:
	var users: Array = []	
	for recipient_id in self.recipients_ids:
		var user: User = self.get_recipient_by_id(recipient_id)
		if user:
			users.append(user)
	return users

# Gets a recipient by id.
func get_recipient_by_id(id: int) -> User:
	return self.get_container().users.get(id) if self.has_recipient(id) else null

# Checks if a user is a recipient of the channel.
func has_recipient(id: int) -> bool:
	return id in self.recipients_ids

# doc-hide
func get_class() -> String:
	return "PrivateChannel"

func _update(data: Dictionary) -> void:
	._update(data)
	recipients_ids = data.get("recipients_ids", recipients_ids)

func __set(_value) -> void:
	pass
