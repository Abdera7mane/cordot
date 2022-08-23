# doc-hide
class_name ChannelPacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"CHANNEL_CREATE": "_on_channel_create",
	"CHANNEL_UPDATE": "_on_channel_update",
	"CHANNEL_DELETE": "_on_channel_delete",
	"CHANNEL_PINS_UPDATE": "_on_channel_pins_update",
	"STAGE_INSTANCE_CREATE": "_on_stage_instance_create",
	"STAGE_INSTANCE_UPDATE": "_on_stage_instance_update",
	"STAGE_INSTANCE_DELETE": "_on_stage_instance_delete"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

func _on_channel_create(fields: Dictionary) -> void:
	var channel: Channel = _entity_manager.get_or_construct_channel(fields)
	if channel.is_guild():
		channel.guild._add_channel(channel.id)
		self.emit_signal("transmit_event", "channel_created", [channel.guild, channel])

func _on_channel_update(fields: Dictionary) -> void:
	var id: int = fields["id"] as int
	var channel: Channel = _entity_manager.get_channel(id)
	if channel:
		var old: Channel = channel.clone()
		_entity_manager.channel_manager.update_channel(channel, fields)
		self.emit_signal("transmit_event", "channel_updated", [channel.guild, old, channel])

func _on_channel_delete(fields: Dictionary) -> void:
	var channel: Channel = _entity_manager.get_or_construct_channel(fields, false)
	if channel:
		if channel.is_guild():
			channel.guild._remove_channel(channel.id)
		_entity_manager.remove_channel(channel.id)
		self.emit_signal("transmit_event", "channel_deleted", [channel.guild, channel])

func _on_channel_pins_update(fields: Dictionary) -> void:
	var channel_id: int = fields["channel_id"] as int
	var channel: TextChannel = _entity_manager.get_channel(channel_id)
	if not channel and fields.has("guild_id"):
		var guild_id: int = fields["guild_id"] as int
		var guild: Guild = _entity_manager.get_guild(guild_id)
		channel = guild.get_thread(channel_id)
	var last_pin: int = TimeUtil.iso_to_unix(Dictionaries.get_non_null(fields, "last_pin_timestamp", ""))
	
	if channel:
		channel._update({last_pin_timestamp = last_pin})
		emit_signal("transmit_event", "channel_pins_updated", [channel, last_pin])

# warning-ignore:unused_argument
func _on_stage_instance_create(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_stage_instance_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_stage_instance_delete(fields: Dictionary) -> void:
	pass

func get_class() -> String:
	return "ChannelPacketsHandler"
