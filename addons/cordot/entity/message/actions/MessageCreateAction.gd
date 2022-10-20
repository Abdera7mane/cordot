# Message action to send a message to a channel.
class_name MessageCreateAction extends MessageAction

# Maxiumum number of stickers in a message.
const MAX_STICKERS: int = 3

var _tts: bool                     setget __set
var _message_reference: Dictionary setget __set
var _sticker_ids: Array            setget __set

# Constructs a new `MessageCreateAction` instance.
func _init(rest: DiscordRESTMediator, channel_id: int).(rest, channel_id) -> void:
	_method = "create_message"

# Sends the message.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func submit():
	return _submit()

# Enables/Disables TTS (Text To Speach) to the message. `false` by default.
func set_tts(value: bool) -> MessageCreateAction:
	_tts = value
	return self

# References a message by `message_id` to reply to. When `fail_on_error` is `true`
# the action fails if the referenced message does not exist.
func reply_to(message_id: int, fail_on_error: bool = true) -> MessageCreateAction:
	_message_reference = {
		message_id = str(message_id),
		fail_if_not_exists = fail_on_error
	}
	return self

# Attach a sticker to the message.
func add_sticker(sticker_id: int) -> MessageCreateAction:
	if _sticker_ids.size() < MAX_STICKERS:
		_sticker_ids.append(str(sticker_id))
	else:
		push_error("Message stickers are limited to %d" % MAX_STICKERS)
	return self

# doc-hide
func get_class() -> String:
	return "MessageCreateAction"

func _can_submit() -> bool:
	return not _content.empty() or _embeds.size() or _components.size()\
		   or _sticker_ids.size()

func _get_message_data() -> Dictionary:
	var data: Dictionary = {
		tts = _tts,
		sticker_ids = _sticker_ids
	}
	
	Dictionaries.merge(data, ._get_message_data())
	
	return data

func _get_arguments() -> Array:
	return [_channel_id, _get_message_data()]

func __set(_value) -> void:
	pass

