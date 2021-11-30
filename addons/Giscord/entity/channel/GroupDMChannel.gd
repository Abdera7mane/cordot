class_name GroupDMChannel extends PrivateChannel

var name: String      setget __set
var icon_hash: String setget __set
var owner_id: int     setget __set
var owner: User       setget __set, get_owner

func _init(data: Dictionary).(data) -> void:
	type = Type.GROUP_DM
	
	name = data["name"]
	owner_id = data["owner_id"]
	icon_hash = data.get("icon_hash", "")

func get_owner() -> User:
	return self.get_recipient_by_id(owner_id)

func get_class() -> String:
	return "GroupDMChannel"

func _update(data: Dictionary) -> void:
	._update(data)
	name = data.get("name", name)
	icon_hash = data.get("icon_hash", icon_hash)
	owner_id = data.get("owner_id", owner_id)

func __set(_value) -> void:
	pass
