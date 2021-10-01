class_name TextChannel extends Channel

# warning-ignore:unused_signal
# warning-ignore:unused_signal
signal message_received(message)
signal message_deleted(message_id)

var last_message_id: int  setget __set
var last_message: Message setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	last_message_id = data["last_message_id"]

func fetch_last_message_async() -> Message:
	return yield()

func get_class() -> String:
	return "TextChannel"

func __set(_value) -> void:
	.__set(_value)
