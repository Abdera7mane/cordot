# doc-hide
class_name PacketHandlerWrapper extends PacketHandler
var _packets: Dictionary
var _instance: Object

func _init(object: Object, packets: Dictionary) -> void:
	self._packets = packets
	self._instance = object

func get_packets() -> Dictionary:
	return _packets

func _operate(function: String, payload: Dictionary) -> void:
	self._instance.callv(function, [payload])
