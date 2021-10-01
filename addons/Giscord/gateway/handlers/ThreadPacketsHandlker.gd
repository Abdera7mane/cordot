class_name ThreadPacketshandler extends PacketHandler

const PACKETS: Dictionary = {
	"THREAD_CREATE": "_on_thread_create",
	"THREAD_UPDATE": "_on_thread_update",
	"THREAD_DELETE": "_on_thread_delete",
	"THREAD_LIST_SYNC": "_on_thread_list_sync",
	"THREAD_MEMBER_UPDATE": "_on_thread_member_update",
	"THREAD_MEMBERS_UPDATE": "_on_thread_members_update"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

# warning-ignore:unused_argument
func _on_thread_create(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_thread_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_thread_delete(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_thread_list_sync(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_thread_member_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_thread_members_update(fields: Dictionary) -> void:
	pass

func get_packets() -> Dictionary:
	return PACKETS

func get_class() -> String:
	return "ThreadPacketshandler"
