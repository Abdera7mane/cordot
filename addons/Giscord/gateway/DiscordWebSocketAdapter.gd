class_name DiscordWebSocketAdapter extends BaseWebSocketAdapter

const ENCODING: String = "json"

var _connection_state: ConnectionState setget __set

func _init(connection_state: ConnectionState) -> void:
	self.name = "GeneralWebSocketAdapter"
	
	_connection_state = connection_state
	
	# warning-ignore:return_value_discarded
	self.connect("packet_received", self, "_on_packet")

func get_url():
	return Discord.GATEWAY_URL % [Discord.GATEWAY_VERSION, ENCODING]

func _connection_established(protocol: String) -> void:
	print("connected !, pootocol: %s" % protocol)

func _connection_closed(was_clean_close: bool) -> void:
	print("bye bye: %s" % str(was_clean_close)) # sad :(
	_heartbeat_timer.stop()

func _connection_error() -> void:
	pass

func _on_packet(packet: DiscordPacket) -> void:
	var opcode: int = packet.get_opcode()
	match opcode:
		GatewayOpcodes.General.DISPATCH:
			print(packet.get_event_name())
			last_sequence = packet.get_sequence()
			self.dispatch_packet(packet)
		GatewayOpcodes.General.HEARTBEAT:
			self._beat()
		GatewayOpcodes.General.RECONNECT:
			print("Reconnecting")
			self.reconnect_to_gateway()
		GatewayOpcodes.General.INVALID_SESSION:
			#I'm lazy, maybe for an other time
			pass
		GatewayOpcodes.General.HELLO:
			print("Identifying...")
			var pkt: Packet
			
			if (_connection_state.session_id.empty()):
				pkt = Packets.IdentifyPacket.new(_connection_state)
			else:
				pkt = Packets.ResumePacket.new(_connection_state, last_sequence)
				
			self.send_packet(pkt)
			self._beat()
			
			var wait_time: int = packet.get_data()["heartbeat_interval"] / 1000
			_heartbeat_timer.start(wait_time)
		GatewayOpcodes.General.HEARTBEAT_ACK:
			latency = OS.get_system_time_msecs() - last_beat
		_:
			push_warning("Unhandled Opcode: %d" % opcode)

func get_class() -> String:
	return "DiscordWebsocketAdapter"

func __set(_value) -> void:
	.__set(_value)
