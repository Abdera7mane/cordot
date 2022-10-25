# Represents a class which contains methods for handle application commands.
class_name ApplicationCommandExecutor

var _component_awaiters: Array

# doc-hide
func interact(interaction: DiscordInteraction) -> void:
	if interaction.is_command():
		match interaction.data.type:
			DiscordApplicationCommand.Type.CHAT_INPUT:
				_on_slash_command(interaction as DiscordSlashCommand)
			DiscordApplicationCommand.Type.USER:
				_on_user_command(interaction as DiscordUserCommand)
			DiscordApplicationCommand.Type.MESSAGE:
				_on_message_command(interaction as DiscordMessageCommand)
	
	elif interaction.is_autocomplete():
		var autocomplete := interaction as DiscordAutocompleteInteraction
		_on_autocomplete(autocomplete)
		
	elif interaction.is_message_component():
		for awaiter in _component_awaiters:
			awaiter.pass_event(interaction as DiscordMessageComponentInteraction)

# Waits for message components interaction event, based on a `message_id`,
# `timeout` time in milliseconds and an optional `repeat` count of how many
# events to catch.
func await_components(
	message_id: int, timeout: int, repeat: int = -1
) -> MessageComponentAwaiter:
	var awaiter := MessageComponentAwaiter.new(message_id, timeout, repeat)
	# warning-ignore:return_value_discarded
	awaiter.connect("timeout", self, "_on_awaiter_timeout", [awaiter], CONNECT_DEFERRED)
	_component_awaiters.append(awaiter)
	return awaiter

func _on_awaiter_timeout(awaiter: MessageComponentAwaiter) -> void:
	_component_awaiters.erase(awaiter)

# Called when a slash command interaction is recieved.
#
# doc-show
# doc-qualifiers:virtual
func _on_slash_command(_command: DiscordSlashCommand) -> void:
	pass

# Called when a user command interaction is recieved.
#
# doc-show
# doc-qualifiers:virtual
func _on_user_command(_command: DiscordUserCommand) -> void:
	pass

# Called when a message command interaction is recieved.
#
# doc-show
# doc-qualifiers:virtual
func _on_message_command(_command: DiscordMessageCommand) -> void:
	pass

# Called when a autocomplete interaction is recieved.
#
# doc-show
# doc-qualifiers:virtual
func _on_autocomplete(_interaction: DiscordAutocompleteInteraction) -> void:
	pass

# Helper class to listen for message components interaction events of a single
# message.
#
# example usage:
#
#	var message_id: int = 1234567890
#	var timeout_id: int = 20_000 # 20 seconds
#	var awaiter := await_components(message_id, 20_000)
#
#	while yield(awaiter.wait(), "completed"):
#		var event := awaiter.get_event()
#		match event.data.custom_id:
#			"hello":
#				event.create_reply("hello").submit()
#			"bye":
#				event.create_reply("Good bye").submit()
#	
#	# Timedout
class MessageComponentAwaiter:
	
	# Emitted when the awaiter timeouts.
	signal timeout()
	
	var _message_id: int                           setget __set
	var _timeout: int                              setget __set
	var _repeat: int                               setget __set
	var _start: int                                setget __set
	var _event: DiscordMessageComponentInteraction setget __set
	var _coroutine: GDScriptFunctionState          setget __set
	
	# doc-hide
	func _init(message_id: int, timeout: int, count: int = -1) -> void:
		_message_id = message_id
		_timeout = timeout
		_repeat = count
	
	# Waits for a message components event. Returns `false` on timeout or when
	# `repeat` count reaches `0`.
	#
	# doc-qualifiers:coroutine
	# doc-override-return:bool 
	func wait() -> bool:
		_event = null
		if _timeout <= 0:
			print(_timeout)
		if _repeat == 0:
			yield(Awaiter.submit(), "completed")
			return false
		
		if _start == 0:
			_start = OS.get_ticks_msec()
		else:
			_timeout -= OS.get_ticks_msec() - _start
		
		# warning-ignore:function_may_yield
		_coroutine = _await_component_event()
		
		var start: int = OS.get_ticks_msec()
		_event = yield(
			Awaiter.wait_for_coroutine(_coroutine, _timeout), "completed"
		)
		var end: int = OS.get_ticks_msec()
		_timeout -= end - start
		
		_coroutine = null
		
		if not _event:
			emit_signal("timeout")
		
		return _event != null
	
	# Gets the interaction event after `wait()` has returned `true`.
	func get_event() -> DiscordMessageComponentInteraction:
		return _event
	
	# doc-hide
	func pass_event(event: DiscordMessageComponentInteraction) -> void:
		if not _coroutine:
			return
		
		if event and event.message_id == _message_id:
			if _repeat > 0:
				_repeat -= 1
			_coroutine.resume(event)
	
	func _await_component_event() -> DiscordMessageComponentInteraction:
		return yield()
	
	func __set(_value) -> void:
		pass

