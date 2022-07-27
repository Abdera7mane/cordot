class_name RESTRateLimitBucket

# warning-ignore-all:shadowed_variable

signal queue_update()

var key: String
var limit: int
var remaining: int:
	get = get_remaining
var reset: int                               # uses engine ticks in milliseconds
var reset_after: int:
	set = set_reset_after  # in milliseconds
var auto_reset: bool

var requests: Array

func _init(key: String, limit: int, remaining: int, reset_after: int = -1) -> void:
	self.key = key
	self.limit = limit
	self.remaining = remaining
	if reset_after >= 0:
		self.reset_after = reset_after

func get_remaining() -> int:
	if reset <= Time.get_ticks_msec():
		remaining = limit
		if auto_reset:
			reset = reset_after + Time.get_ticks_msec()
	return remaining

func set_reset_after(after: int) -> void:
	reset_after = after
	reset = reset_after + Time.get_ticks_msec()

func use() -> void:
	self.remaining -= 1

func delay() -> bool:
	return self.remaining == 0

func time_to_wait() -> int:
	return int(max(0, reset - Time.get_ticks_msec()))

func add_to_queue(request: RestRequest) -> void:
	requests.append(request)
	queue_update.emit()

func remove_from_queue(request: RestRequest) -> void:
	requests.erase(request)
	queue_update.emit()

func wait_for_queue(request: RestRequest) -> void:
	assert(request in requests, "request is not found in requests")
	while requests.size() > 1 and requests[0] != request:
		await queue_update
