class_name DiscordClient extends Node

# warning-ignore:unused_signal
signal client_ready(user)
# warning-ignore:unused_signal
signal resumed()
# warning-ignore:unused_signal
signal reconnected()
# warning-ignore:unused_signal
signal channel_created(channel)
# warning-ignore:unused_signal
signal channel_updated(channel)
# warning-ignore:unused_signal
signal channel_deleted(channel)
# warning-ignore:unused_signal
signal channel_pins_updated(channel)
# warning-ignore:unused_signal
signal thread_created(thread)
# warning-ignore:unused_signal
signal thread_updated(thread)
# warning-ignore:unused_signal
signal thread_deleted(thread)
# warning-ignore:unused_signal
signal thread_list_sync()
# warning-ignore:unused_signal
signal thread_member_updated(thread)
# warning-ignore:unused_signal
signal thread_members_updated(thread)
# warning-ignore:unused_signal
signal typing_started(channel, user, timestamp)
# warning-ignore:unused_signal
signal guild_created(guild)
# warning-ignore:unused_signal
signal guild_updated(guild)
# warning-ignore:unused_signal
signal guild_deleted(guild)
# warning-ignore:unused_signal
signal guild_ban_removed(guild, member)
# warning-ignore:unused_signal
signal guild_emojis_updated(guild, emoji)
# warning-ignore:unused_signal
signal guild_integrations_updated(guild, integration)
# warning-ignore:unused_signal
signal guild_role_created(role)
# warning-ignore:unused_signal
signal guild_role_updated(role)
# warning-ignore:unused_signal
signal guild_role_deleted(role)
# warning-ignore:unused_signal
signal interaction_created(interaction)
# warning-ignore:unused_signal
signal interaction_updated(interaction)
# warning-ignore:unused_signal
signal interaction_deleted(interaction)
# warning-ignore:unused_signal
signal interaction_triggered(interaction)
# warning-ignore:unused_signal
signal invite_created(invite)
# warning-ignore:unused_signal
signal invite_deleted(invite)
# warning-ignore:unused_signal
signal member_joined(guild, member)
# warning-ignore:unused_signal
signal member_left(guild, member)
# warning-ignore:unused_signal
signal member_updated(guild, member)
# warning-ignore:unused_signal
signal message_sent(message)
# warning-ignore:unused_signal
signal message_updated(message)
# warning-ignore:unused_signal
signal message_deleted(message)
# warning-ignore:unused_signal
signal message_bulk_deleted(messages)
# warning-ignore:unused_signal
signal presence_updated(presence)
# warning-ignore:unused_signal
signal stage_instance_created(channel, instance)
# warning-ignore:unused_signal
signal stage_instance_deleted(channel, instance)
# warning-ignore:unused_signal
signal stage_instance_updated(channel, instance)
# warning-ignore:unused_signal
signal user_updated(user)
# warning-ignore:unused_signal
signal reaction_added(message, user, reaction)
# warning-ignore:unused_signal
signal reaction_removed(message, user, reaction)
# warning-ignore:unused_signal
signal reactions_cleared(message, user, reactions)
# warning-ignore:unused_signal
signal reactions_cleared_emoji(message, reaction)
# warning-ignore:unused_signal
signal voice_state_updated(state)
# warning-ignore:unused_signal
signal voice_server_updated(server)
# warning-ignore:unused_signal
signal webhooks_updated(webhook)

var _connection_state: ConnectionState                 setget __set
var _http_client: DiscordHTTPAdapter                   setget __set
var _general_websocket_client: DiscordWebSocketAdapter setget __set
var _voice_websocket_client: VoiceWebSocketAdapter     setget __set
var _entity_manager: BaseDiscordEntityManager          setget __set

func _init(token: String, intents: int = GatewayIntents.UNPRIVILEGED) -> void:
	self.name = "DiscordClient"
	pause_mode = PAUSE_MODE_PROCESS
	
	_connection_state = ConnectionState.new(token, intents)

func login() -> void:
	if not self.is_inside_tree():
		push_error("Not in scene tree !")
		return
	self._prepare_adapters()
	self._general_websocket_client.connect_to_gateway()

func logout() -> void:
	pass

func is_client_connected() -> bool:
	return self._general_websocket_client.is_connected_to_gateway()

func get_token() -> String:
	return self._connection_state.token

func get_intents() -> int:
	return self._connection_state.intents

func get_ping() -> int:
	return self._general_websocket_client.latency

func get_uptime_ms() -> int:
	return self._connection_state.get_uptime_ms()

func get_self() -> User:
	return self._entity_manager.get_user(_connection_state.self_user_id)

func get_user(id: int) -> User:
	return self._entity_manager.get_user(id)

func get_presence(id: int) -> Presence:
	return self._entity_manager.get_presence(id)

func get_guild(id: int) -> Guild:
	return self._entity_manager.get_guild(id)

func get_channel(id: int) -> Channel:
	return self._entity_manager.get_channel(id)

func get_application(id: int) -> DiscordApplication:
	return self._entity_manager.get_application(id)

func get_team(id: int) -> DiscordTeam:
	return self._entity_manager.get_team(id)

func get_class() -> String:
	return "DiscordClient"

func _get_websocket_adapter() -> DiscordWebSocketAdapter:
	var adapter: DiscordWebSocketAdapter = DiscordWebSocketAdapter.new(_connection_state)
	
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

func _get_voice_websocket_adapter() -> VoiceWebSocketAdapter:
	var adapter: VoiceWebSocketAdapter = VoiceWebSocketAdapter.new()
	return adapter

func _get_http_adapter() -> DiscordHTTPAdapter:
	return DiscordHTTPAdapter.new(_connection_state)

func _get_entity_manager() -> BaseDiscordEntityManager:
	return DiscordEntityManager.new()

func _prepare_adapters() -> void:
	_entity_manager = _get_entity_manager()
	_http_client = _get_http_adapter()
	_general_websocket_client = _get_websocket_adapter()
	_voice_websocket_client = _get_voice_websocket_adapter()
	
	self.add_child(_http_client)
	self.add_child(_general_websocket_client)
	self.add_child(_voice_websocket_client)

func _transmit_event(event: String, arguments: Array) -> void:
	if self.has_signal(event):
		self.callv("emit_signal", [event] + arguments)

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	GDUtil.protected_setter_printerr(self, get_stack())
