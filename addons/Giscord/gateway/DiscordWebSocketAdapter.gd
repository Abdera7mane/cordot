class_name DiscordWebSocketAdapter extends BaseWebSocketAdapter

const ENCODING: String = "json"

var _connection_state: ConnectionState setget __set

func _init(connection_state: ConnectionState) -> void:
	name = "GatewayWebSocketAdapter"
	
	_connection_state = connection_state
	
	# warning-ignore:return_value_discarded
	connect("packet_received", self, "_on_packet")

func get_url():
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
			last_sequence = 0
			_connection_state.session_id = ""
			auto_reconnect = false
			reconnecting = true
			_skip_disconnect = true
			disconnect_from_gateway()
			yield(self, "disconnected")
			yield(get_tree().create_timer(rand_range(1.0, 5.0)), "timeout")
			emit_signal("reconnecting")
			connect_to_gateway()
			auto_reconnect = true
			_skip_disconnect = false
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

func get_class() -> String:
	return "DiscordWebsocketAdapter"

func __set(_value) -> void:
	pass
