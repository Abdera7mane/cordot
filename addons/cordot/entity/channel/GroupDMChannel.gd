# Represents a group direct message channel on Discord.
class_name GroupDMChannel extends PrivateChannel

# Group name.
var name: String      setget __set

# The icon hash of the group channel.
var icon_hash: String setget __set

# The owner id of the group channel.
var owner_id: int     setget __set

# The owner of the group channel.
var owner: User       setget __set, get_owner

# doc-hide
func _init(data: Dictionary).(data) -> void:
	type = Type.GROUP_DM
	
	name = data["name"]
	owner_id = data["owner_id"]
	icon_hash = data.get("icon_hash", "")

# Updates the group channel settings.
func edit() -> GroupDMEditAction:
	return GroupDMEditAction.new(get_rest(), self.id)

# `owner` getter.
func get_owner() -> User:
	return self.get_recipient_by_id(owner_id)

# doc-hide
func get_class() -> String:
	return "GroupDMChannel"

func _update(data: Dictionary) -> void:
	._update(data)
	name = data.get("name", name)
	icon_hash = data.get("icon_hash", icon_hash)
	owner_id = data.get("owner_id", owner_id)

func __set(_value) -> void:
	pass
