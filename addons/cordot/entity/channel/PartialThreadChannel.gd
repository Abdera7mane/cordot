class_name PartialThreadChannel extends PartialChannel

var parent_id: int
var archived: bool
var auto_archive_duration: int
var archive_timestamp: int
var locked: bool
var invitable: bool

func _init(data: Dictionary) -> void:
	super(data)
	parent_id = data["parent_id"]
	archived = data["archived"]
	auto_archive_duration = data["auto_archive_duration"]
	archive_timestamp = data["archive_timestamp"]
	locked = data["locked"]
	invitable = data.get("invitable", false)

func get_class() -> String:
	return "PartialThreadChannel"

#func __set(_value) -> void:
#	pass
