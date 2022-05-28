class_name Snowflake

const TIMESTAMP_OFFSET: int = 22
const WORKER_OFFSET: int = 17
const PROCESS_OFFSET: int = 12

const DISCORD_EPOCH: int = 1420070400000

var id: int setget __set

func _init(_id: int) -> void:
	id = _id

func get_timestamp() -> int:
	return (self.id >> TIMESTAMP_OFFSET) + DISCORD_EPOCH

func get_internal_worker_id() -> int:
	return (self.id & 0x3E0000) >> WORKER_OFFSET

func get_internal_process_id() -> int:
	return (self.id & 0x1F000) >> PROCESS_OFFSET

func get_increment() -> int:
	return self.id & 0xFFF

func get_class() -> String:
	return "Snowflake"

func _to_string() -> String:
	return "[%s<%d>:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	pass

# PoolIntArray can not hold 64-bit integers
static func snowflakes2integers(snowflakes: PoolStringArray) -> Array:
	var ints: Array = []
	for snowflake in snowflakes:
		ints.append(snowflake as int)
	return ints
