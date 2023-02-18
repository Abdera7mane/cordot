# Represents a single session in the Discord gateway, receiving events from
# a limited number of guilds. DMs are only sent to shard `0`.
# A single shard can support a maximum of `2500` guilds.
class_name DiscordShard extends Node

# warning-ignore-all:return_value_discarded

# The shard connection states.
enum Status {
	DISCONNECTED,
	CONNECTING,
	CONNECTED,
	RECONNECTING
}

# Emitted when the shard has connected to the gateway.
signal connected()

# Emitted when the shard has disconnected from the gateway.
signal disconnected()

# Emitted when the shard has encountered a connection error.
signal connection_error()

# Emitted when Discord gateway requests the shard to reconnect.
signal reconnect_request()

# Emitted when the shard is attempting to reconnect.
signal reconnecting()

# Emitted when the shard reconnects to the gateway.
signal reconnected()

# Emitted when the shard has resumed its current session.
signal resumed()

# Emitted when the shard has been successfully identified.
signal shard_ready()

# Emitted when the shard sent a heartbeet.
signal heartbeat()

# Emitted when the shard's heartbeet has been acknowledged.
signal heartbeat_ack()

# Emitted when the shard's session has been invalidated.
#
# `bool may_resume`: indicates whether the session can be resumed.
signal invalid_session(may_resume)

# Emitted when the shard receives a packet.
#
# `DiscordPacket packet`: The received packet.
signal packet_received(packet)

# Emitted when the shard receives a connection close request.
#
# `int code`: The websocket close code.  
# `String reason`: The websocket close reason, can be empty.
signal close_request(code, reason)

# The encoding format used in websocket packets.
const ENCODING: String = "json"

# Maximum websocket input buffer size in kilobytes.
const INPUT_BUFFER_SIZE_KB: int = 256

# Maximum number of concurrent outgoing packets.
const OUTPUT_MAX_PACKETS: int = 120

# Maximum outgoing packet size in kilobytes.
const OUTPUT_MAX_PACKET_SIZE_KB: int = 4

# Maximum websocket output buffer size in kilobytes.
const OUTPUT_BUFFER_SIZE_KB: int = OUTPUT_MAX_PACKET_SIZE_KB * OUTPUT_MAX_PACKETS

# The number of unacknowledged heartbeats before dropping the connection.
const MISSED_BEATS_THRESHOLD: int = 5

var _packet_handler: PacketHandler setget __set
var _context: GatewayContext       setget __set

# The shard id.
var id: int                        setget __set

# The gateway url this shard is connected to.
var connected_host: String         setget __set

# The gateway url the shard will connect to if it was requested to reconnect.
var resume_url: String             setget __set

# The current gateway session id.
var session_id: String             setget __set

# Represents the number of events received by this shard on a single session.
var last_sequence: int             setget __set

# Engine time in milliseconds since the last sent heartbeat.
var last_beat: int                 setget __set

# Shard's latency in milliseconds.
var latency_ms: int                setget __set

# The current `DiscordShard.Status`.
var status: int                    setget __set

# Whether the shard is identified and ready to receive events.
var ready: bool                    setget __set

# Number of unacknowledged heartbeets sent to the gateway.
# If this exceeds `MISSED_BEATS_THRESHOLD`, the shard will attempt to reconnect.
var missed_beats: int              setget __set

# The websocket client used by this shard.
var websocket: WebSocketClient     setget __set

# Reference to the timer used to delay heartbeats.
var heartbeat_timer: Timer         setget __set

# doc-hide
func _init(shard_id: int, gateway_context: GatewayContext) -> void:
	id = shard_id
	name = "Shard%d" % id
	_context = gateway_context
	
	_packet_handler = ShardPacketsHandler.new(_context.intents)
	_packet_handler.connect("session_established", self, "_on_new_session")
	_packet_handler.connect("ready", self, "_on_ready")
	_packet_handler.connect("resumed", self, "_on_resumed")
	
	websocket = WebSocketClient.new()
	websocket.set_buffers(
		INPUT_BUFFER_SIZE_KB,
		ProjectSettings.get("network/limits/websocket_client/max_in_packets"),
		OUTPUT_BUFFER_SIZE_KB,
		OUTPUT_MAX_PACKETS
	)
	websocket.connect("connection_established", self, "_on_connection_established")
	websocket.connect("connection_closed", self, "_on_connection_closed")
	websocket.connect("connection_error", self, "_on_connection_error")
	websocket.connect("data_received", self, "_on_data")
	websocket.connect("server_close_request", self, "_on_close_request")
	
	heartbeat_timer = Timer.new()
	heartbeat_timer.name = "Heartbeat"
	heartbeat_timer.connect("timeout", self, "_on_heartbeat_timeout")
	add_child(heartbeat_timer)

# Connects the shard to the gateway. Returns an `ERR_*` code if the websocket
# client can not connet to the `url`.
# Emits `connected` on success or `connection_error` on failure.
func connect_to_gateway(url: String, verify_ssl: bool = true) -> int:
	match status:
		Status.CONNECTING, Status.CONNECTED:
			return ERR_ALREADY_IN_USE
	
	websocket.verify_ssl = verify_ssl
	
	var error: int = websocket.connect_to_url(url)
	if error == OK:
		connected_host = url
		if status != Status.RECONNECTING:
			status = Status.CONNECTING
	
	return error

# Disconnects the shard from the gateway if already connected.
# Emits `disconnected`.
func disconnect_from_gateway(code: int = 1000, reason: String = "") -> void:
	websocket.disconnect_from_host(code, reason)

# Attempts to reconnect to the gateway if already connected and resume the
# session if possible. Emits `reconnecting` and finalize with `reconnected`.
func reconnect_to_gateway() -> void:
	status = Status.RECONNECTING
	disconnect_from_gateway(4000, "reconnecting")
	emit_signal("reconnecting")

# Checks whether the shard is connected to the gateway websocket.
func is_connected_to_gateway() -> bool:
	var ws_status: int = websocket.get_connection_status()
	return ws_status == NetworkedMultiplayerPeer.CONNECTION_CONNECTED

# Sends a `packet` to the gateway. Returns an `ERR_*` code.
func send_packet(packet: Packet) -> int:
	return websocket.get_peer(
		NetworkedMultiplayerPeer.TARGET_PEER_SERVER
	).put_packet(packet.to_bytes())

# Sends a heartbeat.
func beat() -> void:
	send_packet(Packets.HeartBeatPacket.new(last_sequence))
	last_beat = OS.get_ticks_msec()
	missed_beats += 1
	emit_signal("heartbeat")

# Sends an identify payload.
func identify() -> void:
	send_packet(Packets.IdentifyPacket.new(_context, id))

# Sends a resume payload.
func resume() -> void:
	send_packet(Packets.ResumePacket.new(
		_context.token, session_id, last_sequence
	))

# doc-hide
func get_class() -> String:
	return "DiscordShard"

func _reset_session() -> void:
	session_id = ""
	last_sequence = 0

func _process(_delta: float) -> void:
	var ws_status: int = websocket.get_connection_status()
	if ws_status != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		websocket.poll()

func _on_data() -> void:
	var bytes: PoolByteArray = websocket.get_peer(
		NetworkedMultiplayerPeer.TARGET_PEER_SERVER
	).get_packet()
	
	var parse_result: JSONParseResult = JSON.parse(bytes.get_string_from_utf8())
	if parse_result.error != OK:
		var error_message: String = "JSON parse error, at line %d"
		error_message += "\n:" % parse_result.error_line
		error_message += parse_result.error_string
		printerr(error_message)
		return
	
	var data: Dictionary = parse_result.result
	var packet: DiscordPacket = DiscordPacket.new(data)
	_on_packet(packet)
	emit_signal("packet_received", packet)

func _on_connection_established(_protocol: String) -> void:
	var last_status: int = status
	status = Status.CONNECTED
	if last_status == Status.RECONNECTING:
		emit_signal("reconnected")
	else:
		emit_signal("connected")

func _on_new_session(session: String, resume_gateway_url: String) -> void:
	session_id = session
	resume_url = format_url(resume_gateway_url)

func _on_ready() -> void:
	ready = true
	emit_signal("shard_ready")

func _on_resumed() -> void:
	ready = true
	emit_signal("resumed")

func _on_connection_error() -> void:
	emit_signal("connection_error")

func _on_connection_closed(_was_clean_close: bool) -> void:
	ready = false
	heartbeat_timer.stop()
	if status == Status.RECONNECTING:
		connect_to_gateway(resume_url, websocket.verify_ssl)
	else:
		status = Status.DISCONNECTED
		connected_host = ""
		resume_url = ""
		_reset_session()
		emit_signal("disconnected")
	

func _on_close_request(code: int, reason: String) -> void:
	emit_signal("close_request", code, reason)

func _on_heartbeat_timeout() -> void:
	if missed_beats >= MISSED_BEATS_THRESHOLD:
		reconnect_to_gateway()
	else:
		beat()

func _on_packet(packet: DiscordPacket) -> void:
	var opcode: int = packet.get_opcode()
	match opcode:
		GatewayOpcodes.Gateway.DISPATCH:
			last_sequence = packet.get_sequence()
			_packet_handler.handle(packet)
		GatewayOpcodes.Gateway.HEARTBEAT:
			beat()
		GatewayOpcodes.Gateway.RECONNECT:
			emit_signal("reconnect_request")
			reconnect_to_gateway()
		GatewayOpcodes.Gateway.INVALID_SESSION:
			var may_resume: bool = bool(packet.get_data())
			if may_resume:
				resume()
			else:
				_reset_session()
			emit_signal("invalid_session", may_resume)
		GatewayOpcodes.Gateway.HELLO:
			missed_beats = 0
			if not session_id.empty():
				resume()
			beat()
			var interval: float = packet.get_data()["heartbeat_interval"]
			var wait_time: float = interval / 1000
			heartbeat_timer.start(wait_time)
		GatewayOpcodes.Gateway.HEARTBEAT_ACK:
			latency_ms = OS.get_ticks_msec() - last_beat
			missed_beats = 0
			emit_signal("heartbeat_ack")
		_:
			push_warning("Unhandled Opcode: %d" % opcode)

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass

static func format_url(url: String) -> String:
	return "%s/?v=%s&encoding=%s" % [url, Discord.GATEWAY_VERSION, ENCODING]
