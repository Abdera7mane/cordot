class_name DiscordInteraction extends DiscordEntity

enum Type {
	PING                = 1,
	APPLICATION_COMMAND = 2,
	MESSAGE_COMPONENT   = 3,
	AUTOCOMPLETE        = 4,
	MODAL_SUBMIT        = 5
}

enum Callback {
	PONG                     = 1,
	CHANNEL_MESSAGE          = 4,
	DEFERRED_CHANNEL_MESSAGE = 5,
	DEFERRED_UPDATE_MESSAGE  = 6,
	UPDATE_MESSAGE           = 7,
	AUTOCOMPLETE_RESULT      = 8,
	MODAL                    = 9,
}

var application_id: int              setget __set
var application: DiscordApplication  setget __set, get_application
var type: int                        setget __set
var data: DiscordInteractionData     setget __set
var guild_id: int                    setget __set
var guild: Guild                     setget __set, get_guild
var channel_id: int                  setget __set
var channel: TextChannel             setget __set
var member: Guild.Member             setget __set
var user_id: int                     setget __set, get_user_id
var user: User                       setget __set
var token: String                    setget __set
var version: int                     setget __set
var message_id: int                  setget __set
var message: Message                 setget __set
var locale: String                   setget __set
var guild_locale: String             setget __set
var replied: bool                    setget __set
var deferred: bool                   setget __set
var last_followup_id: int            setget __set
var followup_ids: Array              setget __set

func _init(_data: Dictionary).(_data["id"]) -> void:
	application_id = _data["application_id"]
	type = _data["type"]
	data = _data.get("data")
	guild_id = _data.get("guild_id", 0)
	channel_id = _data.get("channel_id", 0)
	member = _data.get("member")
	user_id = _data["user_id"]
	user = _data["user"]
	token = _data["token"]
	version = _data["version"]
	message_id = _data["message_id"]
	message = _data["message"]
	locale = _data.get("locale", "")
	guild_locale = _data.get("guild_locale", "")

func get_application() -> DiscordApplication:
	return self.get_container().applications.get(application_id)

func get_guild() -> Guild:
	return self.get_container().guilds.get(guild_id)

func get_channel() -> TextChannel:
	return self.get_container().channels.get(channel_id)

func get_member() -> Guild.Member:
	return member

func get_user_id() -> int:
	return user_id if not member else member.id

func get_user() -> User:
	return self.get_container().users.get(user_id)

func get_option_name(index: int) -> String:
	return data.options[index]["name"] if has_option(index) else ""

func get_option_value(index: int, default = null): # Variant
	return data.options[index]["value"] if has_option(index) else default

func get_string_option_value(index: int, default: String = "") -> String:
	return get_option_value(index, default)

func get_integer_option_value(index: int, default: int = 0) -> int:
	return get_option_value(index, default)

func get_boolean_option_value(index: int, default: bool = 0) -> bool:
	return get_option_value(index, default)

func get_user_option_value(index: int, default: User = null) -> User:
	var _user: User = null
	var _user_id: int = get_option_value(index, default.id if _user else 0) as int
	if data:
		_user = data.resolved["users"].get(_user_id)
	return _user

func get_channel_option_value(index: int, default: Channel = null) -> Channel:
	var _channel: Channel = null
	var _channel_id: int = get_option_value(index, default.id if _channel else 0) as int
	if data:
		_channel = data.resolved["channels"].get(_channel_id)
	return _channel

func get_role_option_value(index: int, default: Guild.Role = null) -> Guild.Role:
	var role: Guild.Role = null
	var role_id: int = get_option_value(index, default.id if role else 0) as int
	if data:
		role = data.resolved["roles"].get(role_id)
	return role

func get_mentionable_option_value(index: int, default: MentionableEntity = null) -> MentionableEntity:
	var entity: MentionableEntity = null
	var entity_id: int = get_option_value(index, default.id if entity else 0) as int
	if data:
		entity = data.resolved["mentionables"].get(entity_id)
	return entity

func get_number_option_value(index: int, default: float = NAN) -> float:
	return get_option_value(index, default)

func get_attachment_option_value(index: int, default: MessageAttachment = null) -> MessageAttachment:
	var attachment: MessageAttachment = null
	var attachment_id: int = get_option_value(index, default.id if attachment else 0) as int
	if data:
		attachment = data.resolved["attachments"].get(attachment_id)
	return attachment

func has_option(index: int) -> bool:
	return data and data.options.size() >= index

func is_command() -> bool:
	return type == Type.APPLICATION_COMMAND

func is_autocomplete() -> bool:
	return type == Type.AUTOCOMPLETE

func in_guild() -> bool:
	return guild_id != 0

func reply(message_reply: DiscordInteractionMessage) -> bool:
	var fail: bool
	if replied:
		push_error("Already replied to interaction")
		fail = true
	if deferred:
		push_error("Reply to interaction was deferred")
		fail = true
	if fail:
		yield(Awaiter.submit(), "completed")
		return false
	var params: Dictionary = {
		type = Callback.CHANNEL_MESSAGE,
		data = message_reply.to_dict()
	}
	replied = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	), "completed")
	return replied

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

func defer_update() -> bool:
	var fail: bool
	if not replied:
		push_error("Can not defer interaction message update")
		fail = true
	if deferred:
		push_error("Already deferred interaction")
		fail = true
	if fail:
		yield(Awaiter.submit(), "completed")
		return false
	var params: Dictionary = {
		type = Callback.DEFERRED_UPDATE_MESSAGE,
	}
	deferred = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	), "completed")
	return replied

func autocomplete(choices: ApplicationCommandChoicesBuilder) -> void:
	var params: Dictionary = {
		type = Callback.AUTOCOMPLETE_RESULT,
		data = choices.build()
	}
	yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	), "completed")

func create_followup(message_data: DiscordInteractionMessage) -> Message:
	var fail: bool
	if not deferred:
		push_error("Can not create interaction followup, interaction was not deferred")
		fail = true
	elif not replied:
		push_error("Can not create interaction followup, did not reply to interaction")
		fail = true
	if fail:
		return Awaiter.submit()
	var followup: Message = yield(get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_followup_message", [application_id, token, message_data.to_dict()]
	), "completed")
	if followup:
		last_followup_id = followup.id
		followup_ids.append(last_followup_id)
	return followup

func fetch_followup(followup_id: int = last_followup_id) -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_followup_message", [application_id, token, followup_id]
	) if followup_id else Awaiter.submit()

func edit_followup(message_edit: MessageEditData, followup_id: int = last_followup_id) -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"edit_followup_message", [application_id, token, followup_id, message_edit.to_dict()]
	) if followup_id else Awaiter.submit()

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
		if followup_ids.size() > 0:
			last_followup_id = followup_ids.back()
		
	return success

func fetch_response() -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"get_original_response", [application_id, token]
	)

func edit_response(message_edit: MessageEditData) -> Message:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"edit_original_response", [application_id, token, message_edit.to_dict()]
	)

func delete_response() -> bool:
	return get_rest().request_async(
		DiscordREST.INTERACTION,
		"delete_original_response", [application_id, token]
	)

func fetch_channel() -> TextChannel:
	channel = yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_channel", [channel_id]
	) if channel_id else Awaiter.submit(), "completed")
	return channel

func fetch_guild() -> Guild:
	guild = yield(get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild", [guild_id]
	) if guild_id else Awaiter.submit(), "completed")
	return guild

func fetch_message() -> Message:
	message = yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [message_id]
	) if message_id else Awaiter.submit(), "completed")
	return message

func get_class() -> String:
	return "DiscordInteraction"

func __set(_value) -> void:
	pass
