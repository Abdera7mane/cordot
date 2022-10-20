class_name DiscordRESTAction

signal completed(result)

var _type: int      setget __set
var _method: String setget __set

var _mediator: DiscordRESTMediator

# doc-hide
func _init(rest: DiscordRESTMediator) -> void:
	_mediator = rest

# doc-hide
func get_class() -> String:
	return "DiscordRESTAction"

func _submit():
	var result = yield(
		_mediator.request_async(_type, _method, _get_arguments())\
		if _can_submit() else Awaiter.submit()
	, "completed")
	emit_signal("completed", result)
	return result

func _can_submit() -> bool:
	return true

func _get_arguments() -> Array:
	return []

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]

func __set(_value) -> void:
	pass
