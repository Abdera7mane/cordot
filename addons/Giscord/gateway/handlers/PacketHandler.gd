class_name PacketHandler

# warning-ignore:unused_signal
signal transmit_event(event, arguments)

func handle(packet: DiscordPacket) -> void:
	var packets: Dictionary = self.get_packets()
	var packet_name: String = packet.get_event_name()
	if packets.has(packet_name):
		var function_name: String = packets[packet_name]
		_operate(function_name, packet.get_data())

func get_packets() -> Dictionary:
	return {} # Format {"packet_name": "function"}

func _operate(function: String, payload: Dictionary) -> void:
	self.callv(function, [payload])

func get_class() -> String:
	return "PacketHandler"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
