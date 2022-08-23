# doc-hide
class_name Packet

var payload: Dictionary

# warning-ignore:shadowed_variable
func _init(payload: Dictionary = {}) -> void:
	self.payload = payload

func to_bytes() -> PoolByteArray:
	return JSON.print(self.payload).to_utf8()

func get_class() -> String:
	return "Packet"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
