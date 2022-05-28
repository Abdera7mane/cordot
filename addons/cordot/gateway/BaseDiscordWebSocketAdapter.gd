class_name BaseWebSocketAdapter extends Node

signal connected()
signal disconnected()
signal reconnected()
signal connection_error()
signal packet_received(packet)

# warning-ignore-all:return_value_discarded

enum CloseEventCode {
	# Gateway
	UNKOWN_ERROR            = 4000,
	DECODE_ERROR            = 4002,
	SESSION_NO_LONGER_VALID = 4006,
	INVALID_SEQ             = 4007,
	RATE_LIMITED            = 4008,
	INVALID_SHARD           = 4010,
	SHARDING_REQUIRED       = 4011,
	INVALID_API_VERSION     = 4012,
	INVALID_INTENTS         = 4013,
	DISALLOWED_INTENTS      = 4014,
	
	# Voice
	FAILED_TO_DECODE_PAY_LOAD = 4002,
	SESSION_TIMED_OUT         = 4009,
	SERVER_NOT_FOUND          = 4011,
	UNKOWN_PROTOCOL           = 4012,
	DISCONNECTED              = 4014,
	VOICE_SERVER_CRASHED      = 4015,
	UNKOWN_ENCRYPTION_MODE    = 4015
	
	# Shared
	UNKOWN_OPCODE             = 4001,
	NOT_AUTHENTICATED         = 4003,
	AUTHENTICATION_FAILED     = 4004,
	ALREADY_AUTHENTICATED     = 4005,
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
var auto_reconnect: bool = true

func setup():
	if _start != 0:
		_start = OS.get_ticks_msec()
	
	_websocket_client = WebSocketClient.new()
	
	_websocket_client.connect("connection_established", self, "_connection_established")
	_websocket_client.connect("connection_closed", self, "_connection_closed")
	_websocket_client.connect("connection_error", self, "_connection_error")
	_websocket_client.connect("data_received", self, "_on_data")
	_websocket_client.connect("server_close_request", self, "_on_close_request")
	
	_heartbeat_timer = Timer.new()
	_heartbeat_timer.name = "HeartBeatTimer"
	_heartbeat_timer.connect("timeout", self, "_on_heartbeat_timer_timeout")
	
	add_child(_heartbeat_timer)

func connect_to_gateway(verify_ssl: bool = true) -> void:
	if not is_inside_tree():
		push_error("Unexpected method call, %s is not inside a SceneTree" % self)
		return
	
	if _websocket_client:
		var status: int = _websocket_client.get_connection_status()
		if status != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
			push_error("Already connected or connecting")
			return
	
	setup()
	_websocket_client.verify_ssl = verify_ssl
	
	var url: String = get_url()
	var error: int = _websocket_client.connect_to_url(url)
	if error != OK:
		push_error("Could not create websocket connection at url: %s" % url)
		emit_signal("connection_error")
	yield(get_tree().create_timer(timeout_ms), "timeout")
	if not is_connected_to_gateway():
		disconnect_from_gateway(1000, "timeout")

func disconnect_from_gateway(code: int = 1000, reason: String = "") -> void:
	_websocket_client.disconnect_from_host(code, reason)

func send_packet(packet: Packet) -> void:
	var peer: WebSocketPeer = self._websocket_client.get_peer(NetworkedMultiplayerPeer.TARGET_PEER_SERVER)
	var error: int = peer.put_packet(packet.to_bytes())
	if error != OK:
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
	var status: int = NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED
	if _websocket_client:
		status = _websocket_client.get_connection_status()
	return status == NetworkedMultiplayerPeer.CONNECTION_CONNECTED

func close() -> void:
	_websocket_client = null
	_heartbeat_timer.stop()
	_heartbeat_timer.queue_free()

func get_url() -> String:
	return ""

func _beat() -> void:
	send_packet(Packets.HeartBeatPacket.new(last_sequence))
	last_beat = OS.get_ticks_msec()

func _process(_delta: float) -> void:
	if not _websocket_client:
		return
	
	var status: int = _websocket_client.get_connection_status()
	if status != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		_websocket_client.poll()

func _on_data() -> void:
	var bytes: PoolByteArray = _websocket_client.get_peer(NetworkedMultiplayerPeer.TARGET_PEER_SERVER).get_packet()
	var parse_result: JSONParseResult = JSON.parse(bytes.get_string_from_utf8())
	if parse_result.error != OK:
		var error_message: String = "Could not parse packet, error at json string line %d\n:" % parse_result.error_line
		error_message += parse_result.error_string
		printerr(error_message)
		return
	
	var data: Dictionary = parse_result.result
	var packet: DiscordPacket = DiscordPacket.new(data)
	emit_signal("packet_received", packet)

func _connection_established(_protocol: String) -> void:
	if reconnecting:
		reconnecting = false
		emit_signal("reconnected")
	else:
		emit_signal("connected")

func _connection_error() -> void:
	emit_signal("connection_error")

func _connection_closed(_was_clean_close: bool) -> void:
	call_deferred("close")
	if auto_reconnect:
		reconnecting = true
		call_deferred("connect_to_gateway")
	else:
		_start = 0
		emit_signal("disconnected")

func _on_close_request(_code: int, _reason: String) -> void:
	pass

func _on_heartbeat_timer_timeout() -> void:
	_beat()

func get_class() -> String:
	return "BaseDiscordWebSocketAdapter"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
