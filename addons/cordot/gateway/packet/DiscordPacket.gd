# doc-hide
class_name DiscordPacket extends Packet
	
# warning-ignore:shadowed_variable
func _init(payload: Dictionary) -> void:
	self.payload = payload

func is_gateway_dispatch() -> bool:
	return self.payload.has_all(["t", "s"]) and self.get_opcode() == 0

func get_sequence() -> int:
	return self.payload.get("s", 0) as int

func get_event_name() -> String:
	return self.payload.get("t", "") as String

func get_opcode() -> int:
	return self.payload.get("op") as int

func get_data(): # Variant
	return self.payload.get("d")

func _to_string() -> String:
	return "[DiscordPacket:%d]" % self.get_instance_id()
