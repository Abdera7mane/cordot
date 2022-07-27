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

var application_id: int
var application: DiscordApplication:
	get = get_application
var type: int
var data: DiscordInteractionData
var guild_id: int
var guild: Guild:
	get = get_guild
var channel_id: int
var channel: TextChannel
var member: Guild.Member
var user_id: int:
	get = get_user_id
var user: User:
	get = get_user
var token: String
var version: int
var message_id: int
var message: Message
var locale: String
var guild_locale: String
var replied: bool
var deferred: bool
var last_followup_id: int
var followup_ids: Array

func _init(_data: Dictionary) -> void:
	super(_data["id"])
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
	return user if user else member.user

func get_named_option_value(name: String, default = null): # Variant
	var value = default
	for option in data.options:
		if option["name"] == name:
			value = option["value"]
			break
	return value

func get_named_string_option_value(name: String, default: String = "") -> String:
	return get_named_option_value(name, default) as String

func get_named_integer_option_value(name: String, default: int = 0) -> int:
	return get_named_option_value(name, default) as int

func get_named_boolean_option_value(name: String, default: bool = false) -> bool:
	return get_named_option_value(name, default) as bool

func get_named_user_option_value(name: String, default: User = null) -> User:
	var _user: User = default
	var _user_id: int = get_named_integer_option_value(name, default.id if default else 0)
	if data:
		_user = data.resolved["users"].get(_user_id)
	return _user

func get_named_channel_option_value(name: String, default: Channel = null) -> Channel:
	var _channel: Channel = default
	var _channel_id: int = get_named_integer_option_value(name)
	if data:
		_channel = data.resolved["channels"].get(_channel_id, default)
	return _channel

func get_named_role_option_value(name: String, default: Guild.Role = null) -> Guild.Role:
	var role: Guild.Role = default
	var role_id: int = get_named_integer_option_value(name)
	if data:
		role = data.resolved["roles"].get(role_id, default)
	return role

func get_named_mentionable_option_value(name: String, default: MentionableEntity = null) -> MentionableEntity:
	var entity: MentionableEntity = default
	var entity_id: int = get_named_integer_option_value(name)
	if data:
		entity = data.resolved["mentionables"].get(entity_id, default)
	return entity

func get_named_number_option_value(name: String, default: float = NAN) -> float:
	return get_named_option_value(name, default) as float

func get_named_attachment_option_value(index: int, default: MessageAttachment = null) -> MessageAttachment:
	var attachment: MessageAttachment = default
	var attachment_id: int = get_integer_option_value(index)
	if data:
		attachment = data.resolved["attachments"].get(attachment_id, default)
	return attachment

func get_option_name(index: int) -> String:
	return data.options[index]["name"] if has_option(index) else ""

func get_option_value(index: int, default = null): # Variant
	return data.options[index]["value"] if has_option(index) else default

func get_string_option_value(index: int, default: String = "") -> String:
	return get_option_value(index, default) as String

func get_integer_option_value(index: int, default: int = 0) -> int:
	return get_option_value(index, default) as int

func get_boolean_option_value(index: int, default: bool = false) -> bool:
	return get_option_value(index, default) as bool

func get_user_option_value(index: int, default: User = null) -> User:
	var _user: User = default
	var _user_id: int = get_integer_option_value(index)
	if data:
		_user = data.resolved["users"].get("_user_id", default)
	return _user

func get_channel_option_value(index: int, default: Channel = null) -> Channel:
	var _channel: Channel = default
	var _channel_id: int = get_integer_option_value(index)
	if data:
		_channel = data.resolved["channels"].get(_channel_id, default)
	return _channel

func get_role_option_value(index: int, default: Guild.Role = null) -> Guild.Role:
	var role: Guild.Role = default
	var role_id: int = get_integer_option_value(index)
	if data:
		role = data.resolved["roles"].get(role_id, default)
	return role

func get_mentionable_option_value(index: int, default: MentionableEntity = null) -> MentionableEntity:
	var entity: MentionableEntity = default
	var entity_id: int = get_integer_option_value(index)
	if data:
		entity = data.resolved["mentionables"].get(entity_id, default)
	return entity

func get_number_option_value(index: int, default: float = NAN) -> float:
	return get_option_value(index, default) as float

func get_attachment_option_value(index: int, default: MessageAttachment = null) -> MessageAttachment:
	var attachment: MessageAttachment = default
	var attachment_id: int = get_integer_option_value(index)
	if data:
		attachment = data.resolved["attachments"].get(attachment_id, default)
	return attachment

func has_named_option(name: String) -> bool:
	var exists: bool = false
	for option in data.options:
		if option["name"] == name:
			exists = true
			break
	return exists

func has_option(index: int) -> bool:
	return data and data.options.size() > index

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
		await Awaiter.submit()
		return false
	var params: Dictionary = {
		type = Callback.CHANNEL_MESSAGE,
		data = message_reply.to_dict()
	}
	replied = await get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	)
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
		await Awaiter.submit()
		return false
	var params: Dictionary = {
		type = Callback.DEFERRED_CHANNEL_MESSAGE,
	}
	if ephemeral:
		params["data"] = {flags = Message.Flags.EPHEMERAL}
	deferred = await get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	)
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
		await Awaiter.submit()
		return false
	var params: Dictionary = {
		type = Callback.DEFERRED_UPDATE_MESSAGE,
	}
	deferred = await get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	)
	return replied

func autocomplete(choices: ApplicationCommandChoicesBuilder) -> void:
	var params: Dictionary = {
		type = Callback.AUTOCOMPLETE_RESULT,
		data = choices.build()
	}
	await get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_response", [self.id, token, params]
	)

func create_followup(message_data: DiscordInteractionMessage) -> Message:
	var fail: bool
	if not deferred:
		push_error("Can not create interaction followup, interaction was not deferred")
		fail = true
	elif not replied:
		push_error("Can not create interaction followup, did not reply to interaction")
		fail = true
	if fail:
		return await Awaiter.submit()
	var followup: Message = await get_rest().request_async(
		DiscordREST.INTERACTION,
		"create_followup_message", [application_id, token, message_data.to_dict()]
	)
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
		await Awaiter.submit()
		return false

	var success: bool = await get_rest().request_async(
		DiscordREST.INTERACTION,
		"delete_followup_message", [application_id, token, followup_id]
	)

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
	return await get_rest().request_async(
		DiscordREST.INTERACTION,
		"delete_original_response", [application_id, token]
	)

func fetch_channel() -> TextChannel:
	channel = await get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_channel", [channel_id]
	) if channel_id else Awaiter.submit()
	return channel

func fetch_guild() -> Guild:
	guild = await get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild", [guild_id]
	) if guild_id else Awaiter.submit()
	return guild

func fetch_message() -> Message:
	message = await get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [message_id]
	) if message_id else Awaiter.submit()
	return message

func get_class() -> String:
	return "DiscordInteraction"

func __set(_value) -> void:
	pass
