class_name Awaiter

static func wait_for_coroutine(coroutine, timeout: int):
	if not coroutine is GDScriptFunctionState:
		push_error("First argument of wait_for_coroutine is not a coroutine function")
		return yield()
	return wait_for_signal(coroutine, "completed", timeout)

static func wait_for_signal(object: Object, signal_name: String, timeout: int):
	return AwaiterReference.new(object, signal_name).wait(timeout)

class AwaiterReference:

	var object: Object
	var signal_name: String

	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	func _init(object: Object, signal_name: String) -> void:
		self.object = object
		self.signal_name = signal_name

	func wait(timeout: int):

		# warning-ignore:return_value_discarded
		var clock: Clock = Clock.new()
		
		# warning-ignore:function_may_yield
		var state: GDScriptFunctionState = _start()
		
		clock.connect("timeout", self, "_on_timeout", [state])
		clock.start(timeout)
		
		var result = yield(state, "completed")
		
		clock.call_deferred("end")
		
		return result

	func _start():
		return yield(self.object, self.signal_name)
	
	func _on_timeout(state: GDScriptFunctionState) -> void:
		if state.is_valid():
			state.emit_signal("completed")	

class Clock extends Node:
	signal timeout
	
	var _thread: Thread
	var _mutex: Mutex
	
	var is_active: bool
	
	func start(wait_time: int) -> void:
		self._thread = Thread.new()
		self._mutex = Mutex.new()
		
		self.is_active = true
		var error: int = self._thread.start(self, "_run", wait_time)
		if (error == ERR_CANT_CREATE):
			push_error("Couldn't start background thread")
			self.emit_signal("timeout")
			return
		yield(self, "timeout")
		self._mutex.lock()
		self.is_active = false
		self._mutex.unlock()
	
	func end() -> void:
		self._mutex.lock()
		self.is_active = false
		self._mutex.unlock()
		if (self._thread.is_active()):
			self._thread.wait_to_finish()
		self.queue_free()
	
	func _run(wait_time: int) -> void:
		var start: int = OS.get_ticks_msec()
		
		while true:
			self._mutex.lock()
			var resume: bool = self.is_active and wait_time + start >= OS.get_ticks_msec()
			self._mutex.unlock()
			if (not resume):
				break
			# warning-ignore:integer_division
			OS.delay_usec((wait_time * 1000) / 2)
		self.emit_signal("timeout")
