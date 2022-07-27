class_name Awaiter

# warning-ignore-all:unused_signal
# warning-ignore-all:function_may_yield
# warning-ignore-all:return_value_discarded

#static func wait_for_coroutine(coroutine, timeout_ms: int):
#	if not coroutine is GDScriptFunctionState:
#		push_error("First argument of wait_for_coroutine() is not a coroutine function")
#		return submit()
#	return wait_for_signal(coroutine, "completed", timeout_ms)
#
#static func wait_for_signal(object: Object, signal_name: String, timeout_ms: int):
#	return AwaiterReference.new().wait_for_signal(object, signal_name, timeout_ms)

static func wait(time_ms: int) -> void:
	AwaiterReference.new().wait(time_ms)

static func submit() -> void:
	await wait(0)

class AwaiterReference:
	signal interrupted

	var result

	func wait(time: int) -> void:
		await _start_timer(time)

	func wait_for_signal(object: Object, signal_name: Signal, timeout: int):
		var coroutine = await _start_coroutine(object, signal_name)
		var timer = await _start_timer(timeout)

		coroutine.connect("completed", self, "emit_signal", ["interrupted"])
		timer.connect("completed", self, "emit_signal", ["interrupted"])

		await interrupted

		coroutine.disconnect("completed", self, "emit_signal")
		timer.disconnect("completed", self, "emit_signal")

		return result

	func _start_coroutine(object: Object, signal_name: Signal) -> void:
		result = await object.signal_name

	func _start_timer(timeout: int) -> void:
		var tree: SceneTree = Engine.get_main_loop() as SceneTree
		await tree.create_timer(timeout / 1000.0).timeout
