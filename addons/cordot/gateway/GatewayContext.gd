# Provides configurable gateway properties.
class_name GatewayContext

enum {
	# The minimum `large_threshold` value.
	MIN_LARGE_THRESHOLD = 50
	
	# The maximum `large_threshold` value.
	MAX_LARGE_THRESHOLD = 250
}

# The bot token.
var token: String                              setget __set

# The enabled `GatewayIntents` flags.
var intents: int                               setget __set

# Defines the members size threshold in which a guild is considered large.
var large_threshold: int = MIN_LARGE_THRESHOLD setget set_large_threshold

# The total number of shards.
var total_shards: int = 1                      setget set_total_shards

# The shard ids to start by the gateway client.
var shards: PoolIntArray = [0]                 setget set_shards

# doc-hide
func _init(bot_token: String, bot_intents: int) -> void:
	token = bot_token
	intents = bot_intents

# `large_threshold` setter.
func set_large_threshold(value: int) -> void:
	if value > MIN_LARGE_THRESHOLD or value < MAX_LARGE_THRESHOLD:
		large_threshold = value
	else:
		push_error("Gateway 'large_threshold' must be between %d and %d" % [
			MIN_LARGE_THRESHOLD, MAX_LARGE_THRESHOLD
		])

# `total_shards` setter.
func set_total_shards(total: int) -> void:
	if total > 0:
		total_shards = total
	else:
		push_error("Gateway 'total_shards' must be above 0")

# `shards` setter.
func set_shards(shard_ids: PoolIntArray) -> void:
	var _shards: PoolIntArray = []
	shard_ids.sort()
	
	var previous: int = -1
	for id in shard_ids:
		if id < 0:
			push_error("Gateway shard of id '%d' is invalid" % id)
		elif id == previous:
			push_warning("Duplicate shard id: %d" % id)
		else:
			_shards.append(id)
			previous = id
	
	if _shards.size() > total_shards:
		push_error("Assigned shard ids exceeds the number of total shards")
	else:
		shards = _shards

func __set(_value) -> void:
	pass
