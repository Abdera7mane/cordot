# Represent an interaction that accepts message replies and followups.
# Interactions are expected to be replid to within **3 seconds** or
# they get invalidated.
class_name DiscordRepliableInteraction extends DiscordInteraction

# warning-ignore-all:return_value_discarded

# Whether this interaction has been replied to.
var replied: bool         setget __set

# Whether this interaction was deferred.
var deferred: bool        setget __set

# Last followup message id.
var last_followup_id: int setget __set

# List of followup message ids.
var followup_ids: Array   setget __set

# doc-hide
func _init(data: Dictionary).(data) -> void:
	pass

# Create a message reply to respond to the interation.
func create_reply(with_content: String = "") -> InteractionMessageCreateAction:
	var fail: bool
	if replied:
		push_error("Already replied to interaction")
		fail = true
	if deferred:
		push_error("Reply to interaction was deferred")
		fail = true
	if fail:
		return null
	
	var action := InteractionMessageCreateAction.new(get_rest(), self.id, token)
	action.set_content(with_content)
	action.connect("completed", self, "_on_reply_created", [], CONNECT_ONESHOT)
	
	return action

# Defers the reply to the message.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func defer_reply(ephemeral: bool = false) -> bool:
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
		type = Callback.DEFERRED_CHANNEL_MESSAGE,
	}
	if ephemeral:
		params["data"] = {flags = Message.Flags.EPHEMERAL}
	deferred = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	), "completed")
	if deferred and not replied:
		replied = true
	return replied

# Creates a followup message to the interaction. Must reply to the interaction first.
func create_followup(with_content: String = "") -> InteractionFollowupCreateAction:
	if not replied:
		push_error("Can not create interaction followup, did not reply to interaction")
		return null
	
	var action := InteractionFollowupCreateAction.new(
		get_rest(), application_id, token
	)
	action.set_content(with_content)
	action.connect("completed", self, "_on_followup_created", [], CONNECT_ONESHOT)
	
	return action

# Fetches a followup message.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func fetch_followup(followup_id: int = last_followup_id) -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_followup_message", [application_id, token, followup_id]
	) if followup_id else Awaiter.submit()

# Edits a followup message.
func edit_followup(followup_id: int = last_followup_id) -> InteractionFollowupEditAction:
	return InteractionFollowupEditAction.new(
		get_rest(), application_id, token, followup_id
	)

# Deletes a followup message.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_followup(followup_id: int = last_followup_id) -> bool:
	if not followup_id:
		yield(Awaiter.submit(), "completed")
		return false
	
	var success: bool = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"delete_followup_message", [application_id, token, followup_id]
	), "completed")
	
	if success:
		followup_ids.erase(followup_id)
		if followup_ids.size() == 0:
			last_followup_id = 0
		if followup_id == last_followup_id:
			last_followup_id = followup_ids.back()
		
	return success

# Fetches the original message response of the interaction.
#
# doc-qualifiers:coroutine
func fetch_response() -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"get_original_response", [application_id, token]
	)

# Edits the original message response.
func edit_response() -> InteractionMessageEditAction:
	return InteractionMessageEditAction.new(get_rest(), application_id, token)

# Deletes the original message response.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete_response() -> bool:
	return yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"delete_original_response", [application_id, token]
	), "completed")

# doc-hide
func get_class() -> String:
	return "DiscordRepliableInteraction"

func _on_reply_created(success: bool) -> void:
	replied = success

func _on_followup_created(followup: Message) -> void:
	if followup:
		last_followup_id = followup.id
		followup_ids.append(last_followup_id)

func __set(_value) -> void:
	pass
