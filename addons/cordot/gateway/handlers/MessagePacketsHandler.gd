# doc-hide
class_name MessagePacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"MESSAGE_CREATE": "_on_message_create",
	"MESSAGE_UPDATE": "_on_message_update",
	"MESSAGE_DELETE": "_on_message_delete",
	"MESSAGE_DELETE_BULK": "_on_message_bulk_delete",
	"MESSAGE_REACTION_ADD": "_on_reaction_add",
	"MESSAGE_REACTION_REMOVE": "_on_reaction_remove",
	"MESSAGE_REACTION_REMOVE_ALL": "_on_reactions_clear",
	"MESSAGE_REACTION_REMOVE_EMOJI": "_on_reactions_clear_emoji",
	"TYPING_START": "_on_typing_start"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

func _on_message_create(fields: Dictionary) -> void:
	var message_id: int = fields["id"] as int
	var message: Message = _entity_manager.get_message(message_id)
	if message:
		emit_signal("transmit_event", "message_sent", [message])
		return
		
	var channel_id: int = fields["channel_id"] as int
	var channel: Channel = _entity_manager.get_channel(channel_id)
	if channel is Guild.GuildVoiceChannel:
		channel = channel.text_channel
	if not fields.has("guild_id"):
		if channel and _is_ephemeral(fields.get("flags", 0)):
			fields["guild_id"] = channel.guild_id
		
		else:
			channel = _entity_manager.get_or_construct_channel({
				id = channel_id,
				type = Channel.Type.DM,
				recipients = [fields["author"]],
				last_message_id = fields["id"]
			})
	elif not channel:
		var guild_id: int = fields["guild_id"] as int
		var guild: Guild = _entity_manager.get_guild(guild_id)
		channel = guild.get_thread(channel_id)
		
	if channel:
		message = _entity_manager.get_or_construct_message(fields, true)
		channel._update({last_message_id = message.id})
		emit_signal("transmit_event", "message_sent", [message])

func _on_message_update(fields: Dictionary) -> void:
	var message: Message = _entity_manager.get_message(fields["id"] as int)
	if message:
		var old: Message = message.clone()
		_entity_manager.message_manager.update_message(message, fields)
		self.emit_signal("transmit_event", "message_updated", [old, message])

func _on_message_delete(fields: Dictionary) -> void:
	var message: Message = _entity_manager.get_message(fields["id"] as int)
	if message:
		_entity_manager.remove_message(message.id)
		emit_signal("transmit_event", "message_deleted", [message])

func _on_message_bulk_delete(fields: Dictionary) -> void:
	var channel: TextChannel = _entity_manager.get_channel(fields["channel_id"] as int)
	var messages: Array = []
	for snowflake in fields["ids"]:
		var message: Message = _entity_manager.get_message(snowflake as int)
		if message:
			_entity_manager.remove_message(message.id)
			messages.append(message)
	if messages.size() > 0:
		emit_signal("transmit_event", "message_bulk_deleted", [messages, channel])

func _on_reaction_add(fields: Dictionary) -> void:
	var user_id: int = fields["user_id"] as int
	var user: User = _entity_manager.get_user(user_id)
	var is_self: int = user_id == _entity_manager.container.bot_id
	
	if fields.has("guild_id"):
		fields["emoji"]["guild_id"] = fields["guild_id"] as int
	var emoji: Emoji = _entity_manager.get_or_construct_emoji(fields["emoji"])
	emoji.set_meta("partial", true)
	
	var message: Message = _entity_manager.get_message(fields["message_id"] as int)
	var reaction: MessageReaction
	if message and user:
		for _reaction in message.reactions:
			if _reaction.emoji.equals(emoji):
				_reaction._update({count = _reaction.count + 1})
				if is_self:
					_reaction._update({reacted = true})
				reaction = _reaction
				break
		if not reaction:
			reaction = MessageReaction.new(1, is_self, emoji)
			message.reactions.append(reaction)
		emit_signal("transmit_event", "reaction_added", [message, user, reaction])

func _on_reaction_remove(fields: Dictionary) -> void:
	var user_id: int = fields["user_id"] as int
	var user: User = _entity_manager.get_user(user_id)
	var is_self: int = user_id == _entity_manager.container.bot_id
	
	if fields.has("guild_id"):
		fields["emoji"]["guild_id"] = fields["guild_id"] as int
	var emoji: Emoji = _entity_manager.get_or_construct_emoji(fields["emoji"])
	emoji.set_meta("partial", true)
	
	var message: Message = _entity_manager.get_message(fields["message_id"] as int)
	if message and user:
		var reaction: MessageReaction
		for i in range(message.reactions.size()):
			var _reaction: MessageReaction = message.reactions[i]
			if _reaction.emoji.equals(emoji):
				_reaction._update({count = _reaction.count - 1})
				if is_self:
					_reaction._update({reacted = false})
				if _reaction.count == 0:
					message.reactions.remove(i)
				reaction = _reaction
				break
		if not reaction:
			reaction = MessageReaction.new(0, false, emoji)
		emit_signal("transmit_event", "reaction_removed", [message, user, reaction])

func _on_reactions_clear(fields: Dictionary) -> void:
	var message: Message = _entity_manager.get_message(fields["message_id"] as int)
	if message:
		var reactions: Array = message.reactions.duplicate()
		message.reactions.clear()
		emit_signal("transmit_event", "reactions_cleared", [message, reactions])

func _on_reactions_clear_emoji(fields: Dictionary) -> void:
	var emoji: Emoji = _entity_manager.get_or_construct_emoji(fields["emoji"])
	var message: Message = _entity_manager.get_message(fields["message_id"] as int)
	if message:
		for i in range(message.reactions.size()):
			var reaction: MessageReaction = message.reactions[i]
			if reaction.emoji.equals(emoji):
				message.reactions.remove(i)
				emit_signal("transmit_event", "reactions_cleared_emoji", [message, reaction])
				break

func _on_typing_start(fields: Dictionary) -> void:
	var channel_id: int = fields["channel_id"] as int
	var channel: Channel = _entity_manager.get_channel(channel_id)
	if not channel and fields.has("guild_id"):
		var guild_id: int = fields["guild_id"] as int
		var guild: Guild = _entity_manager.get_guild(guild_id)
		channel = guild.get_thread(channel_id)
	if channel is Guild.GuildVoiceChannel:
		channel = channel.text_channel
	var user: User = _entity_manager.get_user(fields["user_id"] as int)
	var timestamp: int = fields["timestamp"]
	if channel and user:
		emit_signal("transmit_event", "typing_started", [channel, user, timestamp])

func get_class() -> String:
	return "MessagePacketsHandler"

static func _is_ephemeral(flags: int) -> bool:
	return BitFlag.new(Message.Flags).put(flags).has(Message.Flags.EPHEMERAL)
