# A client that implements the Discord gateway websocket, and is also a sharding
# manager under the hood. By default, this client will run on a single shard,
# which is configurable with `set_sharding()`. Received events are processed by
# a series of `PacketHandler`s.
class_name DiscordGatewayAdapter extends Node

# The connection status.
enum Status {
	DISCONNECTED,
	CONNECTING,
	CONNECTED
}

# The sharding modes applicable by the client.  
# * `CUSTOM`: Number of shards and their ids are manually specified through
# `set_sharding()` method.
# * `AUTO`: Let the client use the recommended number of shards, this is enabled
# with `enable_auto_sharding()` method.
enum ShardingModes {
	CUSTOM,
	AUTO
}

# Emitted when all shards of client have connected.
signal connected()

# Emitted when all shards have disconnected.
signal disconnected()

# Emitted when the client encounter a connection error.
signal connection_error()

# Emitted when a packet received from a shard.
#
# `DiscordPacket packet`: The received packet.  
# `DiscordShard shard`: The shard which the packet was received from.
signal packet_received(packet, shard)

# warning-ignore-all:return_value_discarded

# Emitted when a `shard` has connected to the gateway.
#
# `DiscordShard shard`: The connected shard.
signal shard_connected(shard)

# Emitted when a `shard` has disconnected from the gateway.
#
# `DiscordShard shard`: The disconnected shard.
signal shard_disconnected(shard)

# Emitted when a `shard` has reconnected to the gateway.
#
# `DiscordShard shard`: The reconnected shard.
signal shard_reconnected(shard)

# Emitted when a `shard` has been identified and started a new session.
#
# `DiscordShard shard`: The identified shard.
signal shard_ready(shard)

# Emitted when a `shard` has resumed its current session.
#
# `DiscordShard shard`: The resumed shard.
signal shard_resumed(shard)

# Emitted when a `shard`'s session became invalid.
#
# `DiscordShard shard`: The invalidated shard's session.  
# `bool may_resume`: Whether the session can be resumed.
signal shard_invalid_session(shard, may_resume)

# Emitted when all shards are identified and ready to receive events.
signal all_shards_ready()

# The amount of time to wait in milliseconds before identifying an other shard.
const IDENTIFY_RESET_MS: int = 5_000

var _packet_handlers: Array  setget __set
var _buckets: Dictionary     setget __set
var _context: GatewayContext setget __set
var _start_time: int         setget __set

# Whether to auto reconnect the client upon disconnection.
var auto_reconnect: bool     setget __set

# The current `Status`.
var status: int              setget __set

# Whether the client is ready to receive events.
var ready: bool              setget __set

# Number of concurrent identify requests allowed per 5 secconds.
var max_concurrency: int     setget __set

# The active `ShardingModes` used.
var sharding_mode: int       setget __set

# Key value pair of shard ids and shards.
var shards: Dictionary       setget __set

# Discord's websocket URL.
var gateway_url: String      setget __set

# doc-hide
func _init(gateway_context: GatewayContext) -> void:
	name = "GatewayAdapter"
	
	_context = gateway_context

# Fetches information on Discord's gateway.  
# <https://discord.com/developers/docs/topics/gateway#get-gateway-bot>
func fetch_geteway_info() -> Dictionary:
	return parse_json(yield(
		SimpleHTTPClient.new().request_async(
			(Discord.REST_URL % Discord.REST_VERSION).plus_file("gateway/bot"),
			{
				HTTPHeaders.AUTHORIZATION: "Bot " + _context.token,
				HTTPHeaders.USER_AGENT: "%s (%s, %s)" % [
					Discord.LIBRARY,
					Discord.LIBRARY_URL,
					Discord.LIBRARY_VERSION
				]
			}
		)
	, "completed").body.get_string_from_utf8())

# Connects to Discord's websocket gateway.
# If `reconnect` is `true` all shards will auto reconnect on disconnection.
# Emits `connected` on successful connection, or `connection_error` on failure.
func connect_to_gateway(reconnect = true, verify_ssl: bool = true) -> void:
	if status != Status.DISCONNECTED:
		push_error("This gateway client is already in active connection")
		return
	
	auto_reconnect = reconnect
	
	_buckets.clear()
	
	var info: Dictionary = yield(fetch_geteway_info(), "completed")
	gateway_url = DiscordShard.format_url(info["url"])
	max_concurrency = info["session_start_limit"]["max_concurrency"]
	
	if sharding_mode == ShardingModes.AUTO:
		var recommended_shards: int = info["shards"]
		_context.total_shards = recommended_shards
		_context.shards = range(recommended_shards)
	
	_create_shards(_context.shards)
	
	status = Status.CONNECTING
	
	for shard in shards.values():
		shard.connect_to_gateway(gateway_url, verify_ssl)

# Disconnects the client and all of its shards from the websocket gateway.
# Emits `disconnected` once all shards are disconnected.
func disconnect_from_gateway(code: int = 1000, reason: String = "") -> void:
	auto_reconnect = false
	
	for shard in shards.values():
		shard.disconnect_from_gateway(code, reason)

# Adds a gateway event packet handler.
func add_handler(handler: PacketHandler) -> void:
	if not _packet_handlers.has(handler):
		_packet_handlers.append(handler)

# Removes a gateway event packet handler.
func remove_handler(handler: PacketHandler) -> void:
	_packet_handlers.erase(handler)

# Checks if the client is connected to the gateway.
func is_connected_to_gateway() -> bool:
	return status == Status.CONNECTED

# Configures the sharding options of the current client, must be called before
# `login()`.
# `total_shards` defines the number sessions the bot will be devided into,
# must be greater or equal to `1`.
# `shards` has to contain the ids of the shards that should be started by this
# client, a shard id is zero indexed and `shards` must be lower or equal than
# `total_shards`. If `shards` is not set, the client will start all shards from
# the `0`th shard to the `total_shards`th shard.
func set_sharding(total_shards: int, shard_ids: PoolIntArray = []) -> void:
	if status != Status.DISCONNECTED:
		push_error("'set_sharding()' must be called before connecting to gateway")
		return
		
	sharding_mode = ShardingModes.CUSTOM
	if shard_ids.empty():
		shard_ids = range(total_shards)
	_context.set_total_shards(total_shards)
	_context.set_shards(shard_ids)

# Lets the client use the recommended number of shards by Discord.
func enable_auto_sharding() -> void:
	sharding_mode = ShardingModes.AUTO

# Limits the offline members list sent per guild.
# Can take values from `50` to `250`, default to `50`.
# Must be called before `login()`.
func set_large_threshold(threshold: int) -> void:
	if is_connected_to_gateway():
		push_error("'set_sharding()' must be called before connecting to gateway")
	else:
		_context.large_threshold = threshold

# Gets the connection uptime milliseconds.
func get_uptime_ms() -> int:
	return OS.get_ticks_msec() - _start_time if is_connected_to_gateway() else 0

# Gets the average latency of all shards in milliseconds.
func get_latency_ms() -> float:
	var latency: float = 0.0
	for shard_id in shards:
		latency += get_shard_latency_ms(shard_id)
	return latency / shards.size()

# Gets a shard's latency in milliseconds.
func get_shard_latency_ms(shard_id: int) -> float:
	return shards[shard_id].latency_ms

# doc-hide
func get_class() -> String:
	return "DiscordGatewayAdapter"

func _identify_shard(shard: DiscordShard) -> void:
	var rate_limit_key: int = shard.id % max_concurrency
	if _buckets.has(rate_limit_key):
		var reset_time: int = _buckets[rate_limit_key]
		var current_time: int = OS.get_ticks_msec()
		var wait_time: float = (reset_time - current_time) / 1000.0
		if wait_time > 0:
			_buckets[rate_limit_key] = reset_time + IDENTIFY_RESET_MS
			yield(get_tree().create_timer(wait_time), "timeout")
	_buckets[rate_limit_key] = OS.get_ticks_msec() + IDENTIFY_RESET_MS
	shard.identify()

func _create_shards(shard_ids: PoolIntArray) -> void:
	for id in shard_ids:
		var shard: DiscordShard = DiscordShard.new(id, _context)
		
		shard.connect("connected", self, "_on_shard_connected", [shard])
		shard.connect("disconnected", self, "_on_shard_disconnected", [shard])
		shard.connect("connection_error", self, "_on_shard_error", [shard])
		shard.connect("reconnected", self, "_on_shard_reconnected", [shard])
		shard.connect("shard_ready", self, "_on_shard_ready", [shard])
		shard.connect("resumed", self, "_on_shard_resumed", [shard])
		shard.connect("invalid_session", self, "_on_shard_invalid_session", [shard])
		shard.connect("packet_received", self, "_on_shard_packet", [shard])
		shard.connect("close_request", self, "_on_shard_close_request", [shard])
		
		add_child(shard)
		
		shards[id] = shard

func _dispatch_packet(packet: DiscordPacket) -> void:
	for handler in _packet_handlers:
		handler.handle(packet)

func _on_shard_connected(shard: DiscordShard) -> void:
	emit_signal("shard_connected", shard)
	
	_identify_shard(shard)
	
	if status == Status.CONNECTED:
		return
	
	for shard in shards.values():
		if shard.status != DiscordShard.Status.CONNECTED:
			return
	
	status = Status.CONNECTED
	
	emit_signal("connected")

func _on_shard_disconnected(shard: DiscordShard) -> void:
	emit_signal("shard_disconnected", shard)
	
	if auto_reconnect:
		shard.connect_to_gateway(gateway_url, shard.websocket.verify_ssl)
		return
	
	for shard in shards.values():
		if shard.status == DiscordShard.Status.CONNECTED:
			return
	
	for shard in shards.values():
		shard.queue_free()
	shards.clear()
	
	status = Status.DISCONNECTED
	ready = false
	_start_time = -1
	
	emit_signal("disconnected")

func _on_shard_error(_shard: DiscordShard) -> void:
	emit_signal("connection_error")

func _on_shard_reconnected(shard: DiscordShard) -> void:
	emit_signal("shard_reconnected", shard)

func _on_shard_ready(shard: DiscordShard) -> void:
	emit_signal("shard_ready", shard)
	if ready:
		return
	
	for shard in get_children():
		if not shard.ready:
			return
	
	ready = true
	_start_time = OS.get_ticks_msec()
	
	emit_signal("all_shards_ready")

func _on_shard_resumed(shard: DiscordShard) -> void:
	emit_signal("shard_resumed", shard)
	

func _on_shard_invalid_session(may_resume: bool, shard: DiscordShard) -> void:
	emit_signal("shard_invalid_session", shard, may_resume)
	
	if not may_resume:
		_identify_shard(shard)

func _on_shard_packet(packet: DiscordPacket, shard: DiscordShard) -> void:
	emit_signal("packet_received", packet, shard)
	if packet.is_gateway_dispatch():
		_dispatch_packet(packet)

func _on_shard_close_request(code: int, _reason: String, shard: DiscordShard) -> void:
	match code:
		GatewayCloseCode.UNKOWN_OPCODE:
			push_error("Unknown Discord gateway opcode was sent")
		GatewayCloseCode.DECODE_ERROR:
			push_error("Invalid payload was sent to Discord gateway")
		GatewayCloseCode.NOT_AUTHENTICATED:
			push_error("Not authenticated to Discord")
		GatewayCloseCode.AUTHENTICATION_FAILED:
			push_error("Invalid bot token provided")
			auto_reconnect = false
		GatewayCloseCode.RATE_LIMITED:
			push_error("Discord Gateway rate limited")
			shard.reconnect_to_gateway()
		GatewayCloseCode.INVALID_SHARD:
			push_error("Invalid shard info were sent")
			auto_reconnect = false
		GatewayCloseCode.SHARDING_REQUIRED:
			push_error("Sharding is required to connect")
			auto_reconnect = false
		GatewayCloseCode.INVALID_API_VERSION:
			push_error("Connnected to an invalid Discord gateway API version")
			auto_reconnect = false
		GatewayCloseCode.INVALID_INTENTS:
			push_error("Invalid Disocrd gateway intents provided")
			auto_reconnect = false
		GatewayCloseCode.DISALLOWED_INTENTS:
			push_error("Disallowed gateway intents provided")
			auto_reconnect = false
	
	if not auto_reconnect:
		disconnect_from_gateway()

func __set(_value) -> void:
	pass
