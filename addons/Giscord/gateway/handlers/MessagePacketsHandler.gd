class_name MessagePacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"MESSAGE_CREATE": "_on_message_created",
	"MESSAGE_UPDATE": "_on_message_updated",
	"MESSAGE_DELETE": "_on_message_deleted",
	"MESSAGE_DELETE_BULK": "_on_message_deleted_bulk",
	"MESSAGE_REACTION_ADD": "_on_message_reaction_added",
	"MESSAGE_REACTION_REMOVE": "_on_message_reaction_removed",
	"MESSAGE_REACTION_REMOVE_ALL": "_on_message_reaction_removed_all",
	"MESSAGE_REACTION_REMOVE_EMOJI": "_on_message_reaction_removed_emoji",
	"TYPING_START": "_on_typing_start"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

# warning-ignore:unused_argument
func _on_message_created(message_data: Dictionary) -> void:
	return
#	var message: Message = self.entity_manager.get_or_construct_message()

# warning-ignore:unused_argument
func _on_message_updated(message_data: Dictionary) -> void:
	return

func _on_message_deleted(_fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_message_deleted_bulk(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_message_reaction_added(fields: Dictionary) -> void:
	return
#	var user_id: int = fields.user_id as int
#	var channel_id: int = fields.channel_id as int
#	var message_id: int = fields.message_id as int
#	var guild_id: int
#	var member: Guild.Member
#
#	if fields.has("guild_id"):
#		guild_id = fields.guild_id
#		member
#
#	var channel: TextChannel = null
#	var message: Message = null
#	var user: User = null
#	var emoji: Emoji = null
#
#	if message:
#		message.emit_signal("reaction_added", emoji, user)

# warning-ignore:unused_argument
func _on_message_reaction_removed(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_message_reaction_removed_all(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_message_reaction_removed_emoji(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_typing_start(fields: Dictionary) -> void:
	var channel: TextChannel = _entity_manager.get_channel(fields["channel_id"] as int)
	var user: User = _entity_manager.get_user(fields["user_id"] as int)
	var timestamp: int = fields["timestamp"]
	self.emit_signal("transmit_event", "typing_started", [channel, user, timestamp])

func get_class() -> String:
	return "MessagePacketsHandler"
