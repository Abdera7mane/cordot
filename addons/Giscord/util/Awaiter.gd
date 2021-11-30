class_name Awaiter

static func wait_for_coroutine(coroutine, timeout: int):
	if not coroutine is GDScriptFunctionState:
		push_error("First argument of wait_for_coroutine() is not a coroutine function")
		return submit()
	return wait_for_signal(coroutine, "completed", timeout)

static func wait_for_signal(object: Object, signal_name: String, timeout: int):
	return AwaiterReference.new(object, signal_name).wait(timeout)

static func wait(timeout: int) -> void:
	yield(AwaiterReference.new().create_clock(timeout), "timeout")

static func submit() -> void:
	wait(0)

class AwaiterReference:

	var object: Object
	var signal_name: String
	var valid: bool

	# warning-ignore:shadowed_variable
	# warning-ignore:shadowed_variable
	func _init(object: Object = null, signal_name: String = "") -> void:
		if object and signal_name.empty():
			push_error("signal_name can not be empty")
			return
		elif not object and not signal_name.empty():
			push_error("object can not be null")
			return
		self.object = object
		self.signal_name = signal_name
		self.valid = true
	
	func create_clock(timeout: int) -> Clock:
		var clock: Clock = Clock.new()
		clock.start(timeout)
		return clock
	
	func wait(timeout: int):
		var clock: Clock
		
		if not valid:
			timeout = 0
		
		if not object:
			clock = create_clock(timeout)
			return yield(clock, "timeout")
			
		# warning-ignore:function_may_yield
		var state: GDScriptFunctionState = _get_function_state()
		clock = create_clock(timeout)
		# warning-ignore:return_value_discarded
		clock.connect("timeout", self, "_on_timeout", [state])
		
		var result = yield(state, "completed")
		
		clock.call_deferred("end")
		
		return result
	
	func _get_function_state():
		yield(self.object, self.signal_name)
	
	func _on_timeout(state: GDScriptFunctionState) -> void:
		if state.is_valid():
			state.emit_signal("completed")

class Clock extends Object:
	signal timeout
	
	var _thread: Thread
	var _mutex: Mutex
	
	var is_active: bool
	
	func start(wait_time: int) -> void:
		self._thread = Thread.new()
		self._mutex = Mutex.new()
		
		self.is_active = true
		var error: int = self._thread.start(self, "_run", wait_time)
		if error == ERR_CANT_CREATE:
			push_error("Couldn't start background thread")
			self.emit_signal("timeout")
			return
		yield(self, "timeout")
		self.is_active = false
	
	func end() -> void:
		self._mutex.lock()
		self.is_active = false
		self._mutex.unlock()
		if self._thread.is_active():
			self._thread.wait_to_finish()
		self.call_deferred("free")
	
	func _run(wait_time: int) -> void:
		if wait_time > 0:
			var start: int = OS.get_ticks_msec()
			while true:
				self._mutex.lock()
				var resume: bool = self.is_active and wait_time + start >= OS.get_ticks_msec()
				self._mutex.unlock()
				if not resume:
					break
				OS.delay_usec(500)
		self.emit_signal("timeout")
