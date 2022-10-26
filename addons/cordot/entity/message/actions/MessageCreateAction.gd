# Message action to send a message to a channel.
class_name MessageCreateAction extends MessageAction

# Maxiumum number of stickers in a message.
const MAX_STICKERS: int = 3

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
	_data["tts"] = value
	return self

# References a message by `message_id` to reply to. When `fail_on_error` is `true`
# the action fails if the referenced message does not exist.
func reply_to(message_id: int, fail_on_error: bool = true) -> MessageCreateAction:
	_data["message_reference"] = {
		message_id = str(message_id),
		fail_if_not_exists = fail_on_error
	}
	return self

# Attach a sticker to the message.
func add_sticker(sticker_id: int) -> MessageCreateAction:
	var stickers: Array = _data.get("sticker_ids", [])
	if stickers.size() < MAX_STICKERS:
		stickers.append(str(sticker_id))
		_data["sticker_ids"] = stickers
	else:
		push_error("Message stickers are limited to %d" % MAX_STICKERS)
	return self

# doc-hide
func get_class() -> String:
	return "MessageCreateAction"

func _can_submit() -> bool:
	return _data.get("content", "").length() or _data.get("embeds", []).size()\
			or _data.get("components", []).size() or _data.get("sticker_ids", []).size()

func _get_message_data() -> Dictionary:
	var data: Dictionary = _data.duplicate()
	
	Dictionaries.merge(data, ._get_message_data(), true)
	
	return data

func _get_arguments() -> Array:
	return [_channel_id, _get_message_data()]

func __set(_value) -> void:
	pass

