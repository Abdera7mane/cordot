class_name DiscordClient extends Node

# warning-ignore-all:unused_signal
# warning-ignore-all:return_value_discarded

enum {
	ERR_WEBSOCKET = 49
}

signal connected()
signal reconnected()
signal resumed()
signal connection_error(error)
signal disconnected()

signal raw_event(event, payload)
signal client_ready(user)
signal channel_created(guild, channel)
signal channel_updated(guild, old, new)
signal channel_deleted(guild, channel)
signal channel_pins_updated(channel, last_pin)
signal thread_created(guild, thread)
signal thread_updated(guild, old, new)
signal thread_deleted(guild, thread)
signal thread_list_sync()
signal thread_member_updated(thread)
signal thread_members_updated(thread)
signal typing_started(channel, user, timestamp)
signal guild_available(guild)
signal guild_unavailable(guild)
signal guild_created(guild)
signal guild_updated(old, new)
signal guild_deleted(guild)
signal guild_ban_added(guild, user)
signal guild_ban_removed(guild, user)
signal guild_emojis_updated(guild, emojis)
signal guild_integrations_updated(guild, integration)
signal guild_role_created(guild, role)
signal guild_role_updated(guild, old, new)
signal guild_role_deleted(guild, role)
signal integration_created(integration)
signal integration_updated(old, new)
signal integration_deleted(integration)
signal interaction_created(interaction)
signal invite_created(invite)
signal invite_deleted(invite)
signal member_joined(guild, member)
signal member_left(guild, member)
signal member_updated(guild, old, new)
signal message_sent(message)
signal message_updated(old, new)
signal message_deleted(message)
signal message_bulk_deleted(messages, channel)
signal presence_updated(presence)
signal stage_instance_created(channel, instance)
signal stage_instance_deleted(channel, instance)
signal stage_instance_updated(channel, old, new)
signal user_updated(old, new)
signal reaction_added(message, user, reaction)
signal reaction_removed(message, user, reaction)
signal reactions_cleared(message, reactions)
signal reactions_cleared_emoji(message, reaction)
signal voice_state_updated(old, new)
signal voice_server_updated(old, new)
signal webhooks_updated(old, new)

var _connection_state: ConnectionState
var entity_manager: BaseDiscordEntityManager
var rest: DiscordRESTAdapter
var gateway_websocket: DiscordWebSocketAdapter
var voice_websocket: VoiceWebSocketAdapter

var commands_map: Dictionary = {
	application = {},
	text = {}
}

var use_http_Packed: bool

func _init(token: String, intents: int = GatewayIntents.UNPRIVILEGED) -> void:
	name = "DiscordClient"
	pause_mode = PAUSE_MODE_PROCESS

	_connection_state = ConnectionState.new(token, intents)

func login() -> void:
	if not is_inside_tree():
		push_error("Not inside a scene tree !")
		emit_signal("connection_error", ERR_UNCONFIGURED)
		return
	_setup()
	gateway_websocket.connect_to_gateway()

func logout() -> void:
	gateway_websocket.auto_reconnect = false
	gateway_websocket.disconnect_from_gateway()

func update_presence(presence: PresenceUpdate) -> void:
	gateway_websocket.send_packet(Packet.new({
		op = GatewayOpcodes.Gateway.PRESENCE_UPDATE,
		d = presence.to_dict()
	}))

func is_client_connected() -> bool:
	return gateway_websocket.is_connected_to_gateway()

func get_token() -> String:
	return self._connection_state.token

func get_intents() -> int:
	return self._connection_state.intents

func get_ping() -> int:
	return self.gateway_websocket.latency

func get_uptime_ms() -> int:
	return self._connection_state.get_uptime_ms()

func get_self() -> User:
	return self.entity_manager.get_self()

func get_user(id: int) -> User:
	return self.entity_manager.get_user(id)

func get_presence(id: int) -> Presence:
	return self.entity_manager.get_presence(id)

func get_guild(id: int) -> Guild:
	return self.entity_manager.get_guild(id)

func get_channel(id: int) -> Channel:
	return self.entity_manager.get_channel(id)

func get_application(id: int) -> DiscordApplication:
	return self.entity_manager.get_application(id)

func get_client_application() -> DiscordApplication:
	return get_application(entity_manager.container.application_id)

func get_team(id: int) -> DiscordTeam:
	return self.entity_manager.get_team(id)

func register_application_command_executor(
	command: String, executor: ApplicationCommandExecutor
) -> void:
	commands_map.application[command] = executor

func register_application_command(
	builder: ApplicationCommandBuilder, guild_id: int = 0
) -> DiscordApplicationCommand:
	if not is_client_connected():
		push_error("Discord client must be connected in order to register  application commands")
		return await get_tree().process_frame

	var application_id: int = get_client_application().id
	if guild_id:
		return rest.application.create_guild_application_command(
			application_id,
			guild_id,
			builder.build()
		)

	return rest.application.create_global_application_command(
		application_id,
		builder.build()
	)

func get_class() -> String:
	return "DiscordClient"

func _create_gateway_websocket(_entity_manager: BaseDiscordEntityManager) -> DiscordWebSocketAdapter:
	var adapter: DiscordWebSocketAdapter = DiscordWebSocketAdapter.new(_connection_state)

	adapter.connect("connected", self, "_on_connected")
	adapter.connect("reconnected", self, "_on_reconnected")
	adapter.connect("connection_error", self, "_on_connection_error")
	adapter.connect("invalid_session", self, "_on_invalid_session")
	adapter.connect("disconnected", self, "_on_disconnected")
	adapter.connect("packet_received", self, "_on_packet")

	var handlers: Array = [
		ChannelPacketsHandler.new(_entity_manager),
		GuildPacketsHandler.new(_entity_manager),
		MessagePacketsHandler.new(_entity_manager),
		ThreadPacketsHandler.new(_entity_manager),
		IntegrationPacketshandler.new(_entity_manager),
		ReadyPacketHandler.new(_connection_state, _entity_manager),
		InteractionPacketsHandler.new(_entity_manager)
	]

	for handler in handlers:
		adapter.add_handler(handler)
		handler.connect("transmit_event", self, "_transmit_event")

	return adapter

func _create_voice_websocket() -> VoiceWebSocketAdapter:
	var adapter: VoiceWebSocketAdapter = VoiceWebSocketAdapter.new()
	return adapter


func _setup() -> void:
	entity_manager = DiscordEntityManager.new()
	var intents_map: Dictionary = GatewayIntents.get_script_constant_map()
	var intents: BitFlag = BitFlag.new(intents_map).put(get_intents())
	entity_manager.cache_flags_from_intents(intents)

	rest = DiscordRESTAdapter.new(_connection_state.token, entity_manager, use_http_Packed)
	gateway_websocket = _create_gateway_websocket(entity_manager)
	voice_websocket = _create_voice_websocket()

	entity_manager.rest_mediator = rest.mediator

	self.add_child(rest)
	self.add_child(gateway_websocket)
	self.add_child(voice_websocket)

func _on_connected() -> void:
	emit_signal("connected")

func _on_connection_error() -> void:
	emit_signal("connection_error", ERR_WEBSOCKET)

func _on_invalid_session(may_resume) -> void:
	if not may_resume:
		entity_manager.reset()

func _on_reconnected() -> void:
	emit_signal("reconnected")

func _on_disconnected() -> void:
	entity_manager.reset()
	emit_signal("disconnected")

func _on_packet(packet: DiscordPacket) -> void:
	if packet.is_gateway_dispatch():
		self.emit_signal("raw_event", packet.get_event_name(), packet.get_data())

func _transmit_event(event: String, arguments: Array) -> void:
	if self.has_signal(event):
		self.callv("emit_signal", [event] + arguments)
		if event == "interaction_created":
			var interaction: DiscordInteraction = arguments[0]
			var command: String = interaction.data.name
			if commands_map.application.has(command):
				var executor: ApplicationCommandExecutor = commands_map.application[command]
				if interaction.is_command():
					executor.interact(interaction)
				elif interaction.is_autocomplete():
					executor.autocomplete(interaction)
	else:
		assert(true, "Transmitted non-existing event '%s'")

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
