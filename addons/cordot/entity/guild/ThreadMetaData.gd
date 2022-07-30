class_name ThreadMetaData

var archived: bool
var auto_archive_duration: int
var archive_timestamp: int
var locked: bool
var invitable: bool
var create_timestamp: int

func _init(data: Dictionary) -> void:
	_update(data)

func clone() -> ThreadMetaData:
	return get_script().new({
		archived = self.archived,
		auto_archive_duration = self.auto_archive_duration,
		archive_timestamp = self.archive_timestamp,
		locked = self.locked,
		invitable = self.invitable,
		create_timestamp = self.create_timestamp
	})

func get_class() -> String:
	return "Guild.ThreadMetaData"

func _update(data: Dictionary) -> void:
	archived = data.get("archived", archived)
	auto_archive_duration = data.get("auto_archive_duration", auto_archive_duration)
	archive_timestamp = data.get("archive_timestamp", archive_timestamp)
	locked = data.get("locked", locked)
	invitable = data.get("invitable", invitable)
	create_timestamp = data.get("create_timestamp", create_timestamp)
