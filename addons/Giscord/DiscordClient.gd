class_name DiscordClient extends Node

# warning-ignore-all:unused_signal

signal raw_event(event, payload)
signal client_ready(user)
signal resumed()
signal reconnected()
signal channel_created(channel)
signal channel_updated(old, new)
signal channel_deleted(channel)
signal channel_pins_updated(channel)
signal thread_created(thread)
signal thread_updated(old, new)
signal thread_deleted(thread)
signal thread_list_sync()
signal thread_member_updated(thread)
signal thread_members_updated(thread)
signal typing_started(channel, user, timestamp)
signal guild_available(guild)
signal guild_unavailable(guild)
signal guild_created(guild)
signal guild_updated(old, new)
signal guild_deleted(guild)
signal guild_ban_removed(guild, member)
signal guild_emojis_updated(guild, emojis)
signal guild_integrations_updated(guild, integration)
signal guild_role_created(role)
signal guild_role_updated(old, new)
signal guild_role_deleted(role)
signal interaction_created(interaction)
signal interaction_updated(old, new)
signal interaction_deleted(interaction)
signal interaction_triggered(interaction)
signal invite_created(invite)
signal invite_deleted(invite)
signal member_joined(guild, member)
signal member_left(guild, member)
signal member_updated(old, new)
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
signal reactions_cleared(message, user, reactions)
signal reactions_cleared_emoji(message, reaction)
signal voice_state_updated(old, new)
signal voice_server_updated(old, new)
signal webhooks_updated(old, new)

var _connection_state: ConnectionState         setget __set

var entity_manager: BaseDiscordEntityManager   setget __set
var rest: DiscordRESTAdapter                   setget __set
var gateway_websocket: DiscordWebSocketAdapter setget __set
var voice_websocket: VoiceWebSocketAdapter     setget __set

func _init(token: String, intents: int = GatewayIntents.UNPRIVILEGED) -> void:
	name = "DiscordClient"
	pause_mode = PAUSE_MODE_PROCESS
	
	_connection_state = ConnectionState.new(token, intents)

func login() -> void:
	if not is_inside_tree():
		push_error("Not inside a scene tree !")
		return
	_prepare_adapters()
	gateway_websocket.connect_to_gateway()

func logout() -> void:
	gateway_websocket.auto_reconnect = false
	gateway_websocket.disconnect_from_gateway()

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

func get_team(id: int) -> DiscordTeam:
	return self.entity_manager.get_team(id)

func get_class() -> String:
	return "DiscordClient"

func _create_gateway_websocket(_entity_manager: BaseDiscordEntityManager) -> DiscordWebSocketAdapter:
	var adapter: DiscordWebSocketAdapter = DiscordWebSocketAdapter.new(_connection_state)
	
	# warning-ignore:return_value_discarded
	adapter.connect("packet_received", self, "_on_packet")
	
	var handlers: Array = [
		ChannelPacketsHandler.new(_entity_manager),
		GuildPacketsHandler.new(_entity_manager),
		MessagePacketsHandler.new(_entity_manager),
		ThreadPacketshandler.new(_entity_manager),
		IntegrationPacketshandler.new(_entity_manager),
		ReadyPacketHandler.new(_connection_state, _entity_manager)
	]
	
	for handler in handlers:
		adapter.add_handler(handler)
		handler.connect("transmit_event", self, "_transmit_event")
	
	return adapter

func _create_voice_websocket() -> VoiceWebSocketAdapter:
	var adapter: VoiceWebSocketAdapter = VoiceWebSocketAdapter.new()
	return adapter


func _prepare_adapters() -> void:
	entity_manager = DiscordEntityManager.new()
	rest = DiscordRESTAdapter.new(_connection_state.token, entity_manager)
	gateway_websocket = _create_gateway_websocket(entity_manager)
	voice_websocket = _create_voice_websocket()
	
	entity_manager.rest_mediator = rest.mediator
	
	self.add_child(rest)
	self.add_child(gateway_websocket)
	self.add_child(voice_websocket)

func _on_packet(packet: DiscordPacket) -> void:
	if packet.is_gateway_dispatch():
		self.emit_signal("raw_event", packet.get_event_name(), packet.get_data())

func _transmit_event(event: String, arguments: Array) -> void:
	if self.has_signal(event):
		self.callv("emit_signal", [event] + arguments)

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
