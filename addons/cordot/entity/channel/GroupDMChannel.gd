class_name GroupDMChannel extends PrivateChannel

var name: String
var icon_hash: String
var owner_id: int
var owner: User:
	get = get_owner

func _init(data: Dictionary) -> void:
	super(data)
	type = Type.GROUP_DM

	name = data["name"]
	owner_id = data["owner_id"]
	icon_hash = data.get("icon_hash", "")

func edit(data: GroupDMEditData) -> GroupDMChannel:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_channel", [data.to_dict()]
	)

func get_owner() -> User:
	return self.get_recipient_by_id(owner_id)

func get_class() -> String:
	return "GroupDMChannel"

func _update(data: Dictionary) -> void:
	super(data)
	name = data.get("name", name)
	icon_hash = data.get("icon_hash", icon_hash)
	owner_id = data.get("owner_id", owner_id)

#func __set(_value) -> void:
#	pass
