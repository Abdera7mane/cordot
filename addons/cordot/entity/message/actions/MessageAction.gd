# Abstract class for message actions.
class_name MessageAction extends DiscordRESTAction

# Maxiumum content length in a message.
const MAX_CONTENT_LENGTH: int = 2000

# Maxiumum number of embeds in a message.
const MAX_EMBEDS: int = 10

var _data: Dictionary setget __set
var _channel_id: int  setget __set

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
		_data["content"] = content
	else:
		push_error("Message content length is limited to %d characters" % MAX_CONTENT_LENGTH)
	return self

# Attach an embed to the message.
func add_embed(embed: MessageEmbedBuilder) -> MessageAction:
	var embeds: Array = _data.get("embeds", [])
	if embeds.size() < MAX_EMBEDS:
		embeds.append(embed)
		_data["embeds"] = embeds
	else:
		push_error("Message embeds are limited to %d" % MAX_EMBEDS)
	return self

# Adds a component to the message.
func add_component(component: MessageComponentBuilder) -> MessageAction:
	var components: Array = _data.get("components", [])
	components.append(component)
	_data["components"] = components
	return self

# Clears embeds from message.
func clear_embeds() -> MessageAction:
	_data["embeds"] = []
	return self

# Clears components from message.
func clear_components() -> MessageAction:
	_data["components"] = []
	return self

# Suppresses all mentions in the message
func suppress_mentions() -> MessageAction:
	_data["allowed_mentions"] = {parse = []}
	return self

# Allows a user with `user_id` to be mentioned in a message.
func allow_user_mention(user_id: int) -> MessageAction:
	var allowed_mentions: Dictionary = _data.get("allowed_mentions", {})
	var users: Array = allowed_mentions.get("users", [])
	if not user_id in users:
		users.append(str(user_id))
	allowed_mentions["users"] = users
	_data["allowed_mentions"] = allowed_mentions
	return self

# Allows all user mentions.
func allow_user_mentions() -> MessageAction:
	var allowed_mentions: Dictionary = _data.get("allowed_mentions", {})
	var parse: Array = allowed_mentions.get("parse", [])
	if not "users" in parse:
		parse.append("users")
	allowed_mentions["parse"] = parse
	_data["allowed_mentions"] = allowed_mentions
	return self

# Allows a role with `role_id` to be mentioned in a message.
func allow_role_mention(role_id: int) -> MessageAction:
	var allowed_mentions: Dictionary = _data.get("allowed_mentions", {})
	var roles: Array = allowed_mentions.get("roles", [])
	if not role_id in roles:
		roles.append(str(role_id))
	allowed_mentions["roles"] = roles
	_data["allowed_mentions"] = allowed_mentions
	return self

# Allows all role mentions.
func allow_role_mentions() -> MessageAction:
	var allowed_mentions: Dictionary = _data.get("allowed_mentions", {})
	var parse: Array = allowed_mentions.get("parse", [])
	if not "roles" in parse:
		parse.append("roles")
	allowed_mentions["parse"] = parse
	_data["allowed_mentions"] = allowed_mentions
	return self

# Allows `@everyone` and `@here` mentions.
func allow_everyone_mention() -> MessageAction:
	var allowed_mentions: Dictionary = _data.get("allowed_mentions", {})
	var parse: Array = allowed_mentions.get("parse", [])
	if not "everyone" in parse:
		parse.append("everyone")
	allowed_mentions["everyone"] = parse
	_data["allowed_mentions"] = allowed_mentions
	return self

# Hides all embeds from the message.
func suppress_embeds(value: bool) -> MessageAction:
	var flags: BitFlag = _data.get("flags", _get_default_flags())
	flags.SUPPRESS_EMBEDS = value
	_data["flags"] = flags
	return self

# doc-hide
func get_class() -> String:
	return "MessageAction"

func _get_message_data() -> Dictionary:
	var data: Dictionary = _data.duplicate()
	
	if data.has("embeds"):
		var _embeds: Array = data["embeds"]
		var embeds: Array = []
		for embed in _embeds:
			embeds.append(embed.build())
		data["embeds"] = embeds
	
	if data.has("flags"):
		data["flags"] = data["flags"].flags
	
	if data.has("components"):
		var _components: Array = data["components"]
		var components: Array = []
		for component in _components:
			components.append(component.build())
		data["components"] = components
	
	return data

func _get_default_flags() -> BitFlag:
	return BitFlag.new({SUPPRESS_EMBEDS = 1 << 2})

func __set(_value) -> void:
	pass

