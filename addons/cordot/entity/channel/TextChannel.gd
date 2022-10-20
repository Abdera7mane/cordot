# Represents a channel on Discord that accepts text messages.
class_name TextChannel extends Channel

# The last message id in the channel.
var last_message_id: int      setget __set

# The last message sent in the channel.
var last_message: BaseMessage setget __set, get_last_message

# Unix time of the last pin of a message in the channel.
var last_pin_timestamp: int   setget __set

# doc-hide
func _init(data: Dictionary).(data["id"]) -> void:
	_update(data)


# Sends a message to this channel.
# `embeds` takes a list of `MessageEmbedBuilder`s
#
# doc-qualifiers:coroutine
func send_message(content: String, tts: bool = false, embeds: Array = []) -> BaseMessage:
	var params: Dictionary = {
		content = content,
		tts = tts
	}
	if embeds.size() > 0:
		params["embeds"] = embeds
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"create_message", [self.id, params]
	)

func create_message(content: String = "") -> MessageCreateAction:
	return MessageCreateAction.new(
		get_rest(), self.id
	).set_content(content) as MessageCreateAction

# Fetches messages sent in this channel.
# 
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_messages(data: ChannelFetchMessgesParams = null) -> Array:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_messages", [self.id, data.to_dict() if data else {}]
	), "completed")

# Fetches a message sent in this channel.
#
# doc-qualifiers:coroutine
func fetch_message(message_id: int) -> BaseMessage:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [self.id, message_id]
	)

# Fetches the last sent message in this channel.
#
# doc-qualifiers:coroutine
func fetch_last_message() -> BaseMessage:
	return fetch_message(last_message_id) if last_message_id else Awaiter.submit()

# Deletes a bulk of messages in this channel.
#
# doc-qualifiers:coroutine
func delete_messages(message_ids: PoolStringArray) -> bool:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"bulk_delete_messages", [self.id, message_ids]
	)

# Gets the last message in this channel from the cache.
func get_last_message() -> BaseMessage:
	return get_container().messages.get(last_message_id)

# doc-hide
func get_class() -> String:
	return "TextChannel"

func _update(data: Dictionary) -> void:
	last_pin_timestamp = data.get("last_pin_timestamp", last_pin_timestamp)
	last_message_id = data.get("last_message_id", last_message_id)

func _clone_data() -> Array:
	return [{
		id = self.id,
		last_pin_timestamp = self.last_pin_timestamp,
		last_message_id = self.last_message_id
	}]

func __set(_value) -> void:
	pass

# Abstract base class of a message on Discord.
class BaseMessage extends DiscordEntity:

	# Channel id of the message.
	var channel_id: int      setget __set

	# The channel the message was sent in.
	var channel: TextChannel setget __set, get_channel
	
	# doc-hide
	func _init(data: Dictionary).(data["id"]) -> void:
		channel_id = data["channel_id"]
		_update(data)
	
	# `channel` getter.
	func get_channel() -> TextChannel:
		return self.get_container().channels.get(channel_id)
	
	func _update(_data: Dictionary) -> void:
		pass
	
	func __set(_value):
		pass
