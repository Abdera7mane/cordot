# doc-hide
class_name ThreadPacketsHandler extends PacketHandler

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

func _on_thread_create(fields: Dictionary) -> void:
	var thread: Guild.ThreadChannel = _entity_manager.get_or_construct_channel(fields)
	var guild: Guild = thread.guild
	if guild:
		emit_signal("transmit_event", "thread_created", [guild, thread])

func _on_thread_update(fields: Dictionary) -> void:
	var thread_id: int = fields["id"] as int
	var guild_id: int = fields["guild_id"] as int
	var guild: Guild = _entity_manager.get_guild(guild_id)
	var thread: Guild.ThreadChannel
	if guild:
		thread = guild.get_thread(thread_id)
		if thread:
			var old: Guild.ThreadChannel = thread.clone()
			_entity_manager.channel_manager.update_channel(thread, fields)
			emit_signal("transmit_event", "thread_updated", [guild, old, thread])
	if not thread:
		thread = _entity_manager.get_or_construct_channel(fields)

func _on_thread_delete(fields: Dictionary) -> void:
	var thread_id: int = fields["id"] as int
	var guild_id: int = fields["guild_id"] as int
	var guild: Guild = _entity_manager.get_guild(guild_id)
	var thread: Guild.ThreadChannel
	if guild:
		thread = guild.get_thread(thread_id)
		if thread:
			emit_signal("transmit_event", "thread_deleted", [guild, thread])

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
	return "ThreadPacketsHandler"
