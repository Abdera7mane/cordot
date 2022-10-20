# Abstract class for message actions.
class_name MessageAction extends DiscordRESTAction

# Maxiumum embeds in a message.
const MAX_CONTENT_LENGTH: int = 2000

# Maxiumum number of embeds in a message.
const MAX_EMBEDS: int = 10

var _channel_id: int               setget __set
var _content: String               setget __set
var _embeds: Array                 setget __set
var _allowed_mentions: Dictionary  setget __set
var _flags: BitFlag                setget __set
var _components: Array             setget __set
var _attachments: Array            setget __set

# doc-hide
func _init(rest: DiscordRESTMediator, channel_id: int).(rest) -> void:
	_type = DiscordREST.CHANNEL
	_channel_id = channel_id

# Executes the action.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func submit():
	return _submit()

# Sets content of the message.
func set_content(content: String) -> MessageAction:
	content = content.strip_edges()
	if content.length() <= MAX_CONTENT_LENGTH:
		_content = content
	else:
		push_error("Message content length is limited to %d characters" % MAX_CONTENT_LENGTH)
	return self

# Attach an embed to the message.
func add_embed(embed: MessageEmbedBuilder) -> MessageAction:
	if _embeds.size() < MAX_EMBEDS:
		_embeds.append(embed)
	else:
		push_error("Message embeds are limited to %d" % MAX_EMBEDS)
	return self

# Adds a component to the message.
func add_component(component: MessageComponentBuilder) -> MessageAction:
	_components.append(component)
	return self

# Suppresses all mentions in the message
func suppress_mentions() -> MessageAction:
	_allowed_mentions = {parse = []}
	return self

# Allows a user with `user_id` to be mentioned in a message.
func allow_user_mention(user_id: int) -> MessageAction:
	var users: Array = _allowed_mentions.get("users", [])
	if not user_id in users:
		users.append(str(user_id))
	_allowed_mentions["users"] = users
	return self

# Allows all user mentions.
func allow_user_mentions() -> MessageAction:
	var parse: Array = _allowed_mentions.get("parse", [])
	if not "users" in parse:
		parse.append("users")
	_allowed_mentions["parse"] = parse
	return self

# Allows a role with `role_id` to be mentioned in a message.
func allow_role_mention(role_id: int) -> MessageAction:
	var roles: Array = _allowed_mentions.get("roles", [])
	if not role_id in roles:
		roles.append(str(role_id))
	_allowed_mentions["roles"] = roles
	return self

# Allows all role mentions.
func allow_role_mentions() -> MessageAction:
	var parse: Array = _allowed_mentions.get("parse", [])
	if not "roles" in parse:
		parse.append("roles")
	_allowed_mentions["parse"] = parse
	return self

# Allows `@everyone` and `@here` mentions.
func allow_everyone_mention() -> MessageAction:
	var parse: Array = _allowed_mentions.get("parse", [])
	if not "everyone" in parse:
		parse.append("everyone")
	_allowed_mentions["everyone"] = parse
	return self

# Hides all embeds from the message.
func suppress_embeds(value: bool) -> MessageAction:
	if not _flags:
		_flags = BitFlag.new({SUPPRESS_EMBEDS = 1 << 2})
	_flags.SUPPRESS_EMBEDS = value
	return self

# doc-hide
func get_class() -> String:
	return "MessageAction"

func _get_message_data() -> Dictionary:
	var embeds: Array = []
	var components: Array = []
	var data: Dictionary = {
		embeds = embeds,
		components = components,
		attachments = _attachments,
	}
	
	if not _content.empty():
		data["content"] = _content
	for embed in _embeds:
		embeds.append(embed.build())
	if _allowed_mentions:
		data["allowed_mentions"] = _allowed_mentions
	if _flags:
		data["flags"] = _flags.flags
	for component in _components:
		components.append(component.build())
	
	return data

func __set(_value) -> void:
	pass

