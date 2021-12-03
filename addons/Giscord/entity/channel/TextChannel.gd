class_name TextChannel extends Channel

var last_message_id: int      setget __set
var last_message: BaseMessage setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	last_message_id = data["last_message_id"]

func send_message(content: String, tts: bool = false, embeds: Array = []) -> BaseMessage:
	var params: Dictionary = {
		content = content,
		tts = tts
	}
	if embeds.size() > 0:
		params["embeds"] = embeds
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"create_message",
		[self.id, params]
	)

func edit_message(message_id: int, content: String, embeds: Array = []):
	var params: Dictionary = {
		content = content
	}
	if embeds.size() > 0:
		params["embeds"] = embeds
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_message",
		[self.id, message_id, params]
	)

func get_class() -> String:
	return "TextChannel"

func _update(data: Dictionary) -> void:
	last_message_id = data.get("last_message_id", last_message_id)

func _clone_data() -> Array:
	return [{
		id = self.id,
		last_message_id = self.last_message_id
	}]

func __set(_value) -> void:
	pass

class BaseMessage extends DiscordEntity:
	var channel_id: int      setget __set
	var channel: TextChannel setget __set, get_channel
	
	func _init(data: Dictionary).(data["id"]) -> void:
		channel_id = data["channel_id"]
		_update(data)
	
	func get_channel() -> TextChannel:
		return self.get_container().channels.get(channel_id)
	
	func _update(_data: Dictionary) -> void:
		pass
	
	func __set(_value):
		pass
