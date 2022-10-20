# Message action to edit an existing message.
class_name MessageEditAction extends MessageAction

var _message_id: int setget __set

# Constructs a new `MessageEditAction` instance.
func _init(
	rest: DiscordRESTMediator, channel_id: int, message_id: int
).(rest, channel_id) -> void:
	_method = "edit_message"

	_message_id = message_id

# Edits the message.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "MessageEditAction"

func _get_arguments() -> Array:
	return [_channel_id, _message_id, _get_message_data()]

func __set(_value) -> void:
	pass

