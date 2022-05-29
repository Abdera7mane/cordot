class_name Awaiter

# warning-ignore-all:unused_signal
# warning-ignore-all:function_may_yield
# warning-ignore-all:return_value_discarded

static func wait_for_coroutine(coroutine, timeout_ms: int):
	if not coroutine is GDScriptFunctionState:
		push_error("First argument of wait_for_coroutine() is not a coroutine function")
		return submit()
	return wait_for_signal(coroutine, "completed", timeout_ms)

static func wait_for_signal(object: Object, signal_name: String, timeout_ms: int):
	return AwaiterReference.new().wait_for_signal(object, signal_name, timeout_ms)

static func wait(time_ms: int) -> void:
	yield(AwaiterReference.new().wait(time_ms), "completed")

static func submit() -> void:
	yield(wait(0), "completed")

class AwaiterReference:
	signal interrupted
	
	var result
	
	func wait(time: int) -> void:
		yield(_start_timer(time), "completed")
	
	func wait_for_signal(object: Object, signal_name: String, timeout: int):
		var coroutine: GDScriptFunctionState = _start_coroutine(object, signal_name)
		var timer: GDScriptFunctionState = _start_timer(timeout)
		
		coroutine.connect("completed", self, "emit_signal", ["interrupted"])
		timer.connect("completed", self, "emit_signal", ["interrupted"])
		
		yield(self, "interrupted")
		
		coroutine.disconnect("completed", self, "emit_signal")
		timer.disconnect("completed", self, "emit_signal")
		
		return result
		
	func _start_coroutine(object: Object, signal_name: String) -> void:
		result = yield(object, signal_name)
	
	func _start_timer(timeout: int) -> void:
		var tree: SceneTree = Engine.get_main_loop() as SceneTree
		yield(tree.create_timer(timeout / 1000.0), "timeout")
