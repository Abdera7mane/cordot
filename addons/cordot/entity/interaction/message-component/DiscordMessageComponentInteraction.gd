# An event fired when a user interacts with a message component.
class_name DiscordMessageComponentInteraction extends DiscordRepliableInteraction

# Message id holding the component.
var message_id: int                   setget __set

# Reference to the message.
var message: Message                  setget __set

# Interaction data assossciated with the event.
var data: DiscordMessageComponentData setget __set

# doc-hide
func _init(_data: Dictionary).(_data) -> void:
	message = _data["message"]
	message_id = message.id
	data = _data["data"]

# Fetches the message holding the component.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func fetch_message() -> Message:
	message = yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [message_id]
	), "completed")
	return message

# Acknowledges the interaction to edit the message later.
func defer_update() -> bool:
	var fail: bool
	if replied:
		push_error("Already replied to interaction")
		fail = true
	if deferred:
		push_error("Already deferred interaction")
		fail = true
	if fail:
		yield(Awaiter.submit(), "completed")
		return false
	var params: Dictionary = {
		type = Callback.DEFERRED_UPDATE_MESSAGE
	}
	deferred = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	), "completed")
	replied = deferred
	return replied

# Updates the message containing the component.
func update_message() -> InteractionMessageUpdateAction:
	if replied:
		push_error("Already replied to interaction")
		return null

	var action := InteractionMessageUpdateAction.new(get_rest(), self.id, token)
	# warning-ignore:return_value_discarded
	action.connect("completed", self, "_on_message_updated", [], CONNECT_ONESHOT)

	return action

# Shows a modal popup.
func show_modal(custom_id: String, title: String) -> InteractionModalAction:
	if replied:
		push_error("Already replied to interaction")
		return null

	var action := InteractionModalAction.new(get_rest(), self.id, token)\
			.set_custom_id(custom_id)\
			.set_title(title)
	# warning-ignore:return_value_discarded
	action.connect("completed", self, "_on_modal_shown", [], CONNECT_ONESHOT)

	return action

func _on_message_updated(success: bool) -> void:
	replied = success

func _on_modal_shown(success: bool) -> void:
	replied = success

# doc-hide
func get_class() -> String:
	return "DiscordMessageComponentInteraction"

func __set(_value) -> void:
	pass
