class_name PartialThreadChannel extends PartialChannel

var parent_id: int             setget __set
var archived: bool             setget __set
var auto_archive_duration: int setget __set
var archive_timestamp: int     setget __set
var locked: bool               setget __set
var invitable: bool            setget __set

func _init(data: Dictionary).(data) -> void:
	parent_id = data["parent_id"]
	archived = data["archived"]
	auto_archive_duration = data["auto_archive_duration"]
	archive_timestamp = data["archive_timestamp"]
	locked = data["locked"]
	invitable = data.get("invitable", false)

func get_class() -> String:
	return "PartialThreadChannel"

func __set(_value) -> void:
	pass
