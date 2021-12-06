class_name DiscordWebSocketAdapter extends BaseWebSocketAdapter


signal invalid_session(may_resume)

const ENCODING: String = "json"

var _connection_state: ConnectionState setget __set

func _init(connection_state: ConnectionState) -> void:
	name = "GatewayWebSocketAdapter"
	
	_connection_state = connection_state
	
	# warning-ignore:return_value_discarded
	connect("packet_received", self, "_on_packet")

func get_url() -> String:
	return Discord.GATEWAY_URL % [Discord.GATEWAY_VERSION, ENCODING]

func _on_packet(packet: DiscordPacket) -> void:
	var opcode: int = packet.get_opcode()
	match opcode:
		GatewayOpcodes.Gateway.DISPATCH:
			last_sequence = packet.get_sequence()
			dispatch_packet(packet)
		GatewayOpcodes.Gateway.HEARTBEAT:
			_beat()
		GatewayOpcodes.Gateway.RECONNECT:
			disconnect_from_gateway(4000, "reconnecting")
		GatewayOpcodes.Gateway.INVALID_SESSION:
			var may_resume: bool = bool(packet.get_data())
			if not may_resume:
				last_sequence = 0
				_connection_state.session_id = ""
			emit_signal("invalid_session", may_resume)
		GatewayOpcodes.Gateway.HELLO:
			var pkt: Packet
			
			if _connection_state.session_id.empty():
				pkt = Packets.IdentifyPacket.new(_connection_state)
			else:
				pkt = Packets.ResumePacket.new(_connection_state, last_sequence)
				
			send_packet(pkt)
			_beat()
			
			var wait_time: int = packet.get_data()["heartbeat_interval"] / 1000
			_heartbeat_timer.start(wait_time)
		GatewayOpcodes.Gateway.HEARTBEAT_ACK:
			latency = OS.get_ticks_msec() - last_beat
		_:
			push_warning("Unhandled Opcode: %d" % opcode)

func _on_close_request(code: int, _reason: String) -> void:
	match code:
		CloseEventCode.AUTHENTICATION_FAILED:
			auto_reconnect = false
			push_error("Invalid bot token provided")
		CloseEventCode.RATE_LIMITED:
			push_error("Discord Gateway rate limited")
		CloseEventCode.INVALID_API_VERSION:
			auto_reconnect = false
			push_error("Connnected to an invalid Discord gateway API version")
		CloseEventCode.INVALID_INTENTS:
			auto_reconnect = false
			push_error("Invalid gateway intents provided")
		CloseEventCode.DISALLOWED_INTENTS:
			auto_reconnect = false
			push_error("Disallowed gateway intents provided")

func get_class() -> String:
	return "DiscordWebsocketAdapter"

func __set(_value) -> void:
	pass
