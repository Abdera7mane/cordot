class_name ConnectionState

var _start: int

var token: String
var intents: int
var session_id: String

func _init(_token: String, _intents: int) -> void:
	token = _token
	intents = _intents

	_start = Time.get_ticks_msec()

func get_uptime_ms() -> int:
	return Time.get_ticks_msec() - _start

func get_class() -> String:
	return "ConnectionState"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
