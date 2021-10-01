class_name BaseWebSocketAdapter extends Node

signal connected()
signal disconnected()
signal connection_error()
signal packet_received(packet)

enum CloseEventCode {
	# General gateway
	UNKOWN_ERROR = 4000,
	DECODE_ERROR = 4002,
	SESSION_NO_LONGER_VALID = 4006,
	INVALID_SEQ = 4007,
	RATE_LIMITED = 4008,
	INVALID_SHARD = 4010,
	SHARDING_REQUIRED = 4011,
	INVALID_API_VERSION = 4012,
	INVALID_INTENTS = 4013,
	DISALLOWED_INTENTS = 4014,
	
	# Voice gateway
	FAILED_TO_DECODE_PAY_LOAD = 4002,
	SESSION_TIMED_OUT = 4009,
	SERVER_NOT_FOUND = 4011,
	UNKOWN_PROTOCOL = 4012,
	DISCONNECTED = 4014,
	VOICE_SERVER_CRASHED = 4015,
	UNKOWN_ENCRYPTION_MODE = 4015
	
	# Both
	UNKOWN_OPCODE = 4001,
	NOT_AUTHENTICATED = 4003,
	AUTHENTICATION_FAILED = 4004,
	ALREADY_AUTHENTICATED = 4005,
}
var _websocket_client: WebSocketClient setget __set
var _heartbeat_timer: Timer            setget __set
var _packet_handlers: Array            setget __set
var _start: int                        setget __set

var timeout_ms: int = 30_000           setget __set
var last_sequence: int = 0             setget __set
var last_beat: int                     setget __set
var latency: int                       setget __set
var reconnecting: bool                 setget __set

func setup():
	if _start != 0:
		_start = OS.get_ticks_msec()
	
	_websocket_client = WebSocketClient.new()
	# warning-ignore:return_value_discarded
	self._websocket_client.connect("connection_established", self, "_connection_established")
	# warning-ignore:return_value_discarded
	self._websocket_client.connect("connection_closed", self, "_connection_closed")
	# warning-ignore:return_value_discarded
	self._websocket_client.connect("connection_error", self, "_connection_error")
	# warning-ignore:return_value_discarded
	self._websocket_client.connect("data_received", self, "_on_data")
	
	_heartbeat_timer = Timer.new()
	_heartbeat_timer.name = "HeartBeatTimer"
	# warning-ignore:return_value_discarded
	_heartbeat_timer.connect("timeout", self, "_on_heartbeat_timer_timeout")
	
	self.add_child(_heartbeat_timer)

func connect_to_gateway(verify_ssl: bool = true, reconnect: bool = false) -> void:
	reconnecting = false
	if _websocket_client and self._websocket_client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		push_error("Already connected or connecting")
		return
	
	if not self.is_inside_tree():
		push_error("Unexpected method call, %s is not inside a SceneTree" % self)
		return
	if not reconnect:
		self.setup()
		_websocket_client.verify_ssl = verify_ssl
	var url: String = self.get_url()
	var error: int = self._websocket_client.connect_to_url(url)
	if error != OK:
		push_error("Could not create websocket connection at url: %s" % url)
		return

func disconnect_from_gateway(code: int = 1000, reason: String = "timeout") -> void:
	if self.is_connected_to_gateway():
		self._websocket_client.disconnect_from_host(code, reason)

func reconnect_to_gateway() -> void:
	reconnecting = true
	self.disconnect_from_gateway(1000, "reconnect")
	yield(self, "disconnected")
	self.connect_to_gateway()

func send_packet(packet: Packet) -> void:
	var error: int = self._websocket_client.get_peer(NetworkedMultiplayerPeer.TARGET_PEER_SERVER).put_packet(packet.to_bytes())
	if (error != OK):
		push_error("unexpected error while sending packet")

func add_handler(handler: PacketHandler) -> void:
	if not _packet_handlers.has(handler):
		_packet_handlers.append(handler)

func remove_handler(handler: PacketHandler) -> void:
	self._packet_handlers.remove(self._packet_handlers.find(handler))

func dispatch_packet(packet: DiscordPacket) -> void:
	for handler in _packet_handlers:
		handler.handle(packet)

func is_connected_to_gateway() -> bool:
	return self._websocket_client.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED

func get_url() -> String:
	return ""

func _beat() -> void:
	self.send_packet(Packets.HeartBeatPacket.new(last_sequence))
	print("beat")
	last_beat = OS.get_system_time_msecs()

func _process(_delta: float) -> void:
	if not self._websocket_client:
		return
	
	match self._websocket_client.get_connection_status():
		NetworkedMultiplayerPeer.CONNECTION_CONNECTING:
			if _start + timeout_ms < OS.get_ticks_msec():
				self.disconnect_from_gateway()
		NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
			return
		
	self._websocket_client.poll()

func _on_data() -> void:
	var bytes: PoolByteArray = self._websocket_client.get_peer(NetworkedMultiplayerPeer.TARGET_PEER_SERVER).get_packet()
	var parse_result: JSONParseResult = JSON.parse(bytes.get_string_from_utf8())
	if (parse_result.error != OK):
		var error_message: String = "Could not parse packet, error at json string line %d\n:" % parse_result.error_line
		error_message += parse_result.error_string
		push_error(error_message)
		printerr(error_message)
		return
	
	var data: Dictionary = parse_result.result
	var packet: DiscordPacket = DiscordPacket.new(data)
	self.emit_signal("packet_received", packet)

func _connection_established(_protocol: String) -> void:
	self.emit_signal("connected")

func _connection_error() -> void:
	self.emit_signal("connection_error")

func _connection_closed(_was_clean_close: bool) -> void:
	if not reconnecting:
		_start = 0
	_heartbeat_timer.stop()
	_heartbeat_timer.queue_free()
	self.emit_signal("disconnected")

func _on_heartbeat_timer_timeout() -> void:
	self._beat()

func get_class() -> String:
	return "BaseDiscordWebSocketAdapter"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	GDUtil.protected_setter_printerr(self, get_stack())
