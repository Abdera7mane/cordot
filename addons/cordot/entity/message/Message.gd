class_name Message extends TextChannel.BaseMessage

enum Type {
	DEFAULT,
	RECIPIENT_ADD,
	RECIPIENT_REMOVE,
	CALL,
	CHANNEL_NAME_CHANGE,
	CHANNEL_ICON_CHANGE,
	CHANNEL_PINNED_MESSAGE,
	GUILD_MEMBER_JOIN,
	GUILD_SUBSCRIPTION,
	GUILD_SUBSCRIPTION_TIER_1,
	GUILD_SUBSCRIPTION_TIER_2,
	GUILD_SUBSCRIPTION_TIER_3,
	CHANNEL_FOLLOW_ADD,
	GUILD_DISCOVERY_DISQUALIFIED                 = 14,
	GUILD_DISCOVERY_REQUALIFIED                  = 15,
	GUILD_DISCOVERY_GRACE_PERIOD_INITIAL_WARNING = 16,
	GUILD_DISCOVERY_GRACE_PERIOD_FINAL_WARNING   = 17,
	THREAD_CREATED                               = 18,
	REPLY                                        = 19,
	APPLICATION_COMMAND                          = 20,
	THREAD_STARTER_MESSAGE                       = 21,
	GUILD_INVITE_REMINDER                        = 22,
	CONTEXT_MENU_COMMAND                         = 23
}

enum Flags {
	CROSSPOSTED            = 1 << 0,
	IS_CROSSPOST           = 1 << 1,
	SUPPRESS_EMBEDS        = 1 << 2,
	SOURCE_MESSAGE_DELETED = 1 << 3,
	URGENT                 = 1 << 4,
	HAS_THREAD             = 1 << 5,
	EPHEMERAL              = 1 << 6,
	LOADING                = 1 << 7,
}

var author_id: int
var author: User:
	get = get_author
var timestamp: int
var type: int
var content: String
var edited_timestamp: int
var mentions: Array
var channel_mentions: Array
var attachments: Array
var embeds: Array
var reactions: Array
var nonce: String
var is_pinned: bool
var webhook_id: int
var webhook: DiscordWebhook
var activity: MessageActivity
var application_id: int
var application: DiscordApplication
var message_reference: MessageReference
var flags: BitFlag
var referenced_message_id: int
var referenced_message: Message:
	get = get_referenced_message
var interaction: MessageInteraction
var components: Array
var sticker_items: Array

func _init(data: Dictionary) -> void:
	super(data)
	author_id = data["author_id"]
	timestamp = data["timestamp"]
	type = data["type"]
	reactions = data.get("recations", [])
	nonce = data.get("nonce", "")
	webhook_id = data.get("webhook_id", 0)
	sticker_items = data.get("stickers", [])
	interaction = data.get("interaction")
	message_reference = data.get("message_reference")
	referenced_message_id = data.get("referenced_message_id", 0)

func get_author() -> User:
	return get_container().users.get(author_id)

func get_referenced_message() -> Message:
	return get_container().messages.get(referenced_message_id)

func edit(message_edit: MessageEditData) -> Message:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"edit_message", [channel_id, self.id, message_edit.to_dict()]
	)

func fetch_message() -> Message:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [channel_id, self.id]
	)

func fetch_referenced_message() -> Message:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [channel_id, referenced_message_id]
	) if referenced_message_id != 0 else Awaiter.submit()

func react(emoji: Emoji) -> bool:
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"create_reaction", [channel_id, self.id, emoji]
	)

func unreact(emoji: Emoji) -> bool:
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_own_reaction", [channel_id, self.id, emoji]
	)

func remove_reaction(user_id: int, emoji: Emoji) -> bool:
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_user_reaction", [channel_id, self.id, emoji, user_id]
	)

func fetch_reactions(emoji: Emoji, after: int = 0, limit: int = 25) -> Array:
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_reactions", [channel_id, self.id, emoji, after, limit]
	)

func clear_all_reactions() -> void:
	await get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_all_reactions", [channel_id, self.id]
	)

func clear_emoji_reactions(emoji: Emoji) -> void:
	await get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_emoji_reactions", [channel_id, self.id, emoji]
	)

func delete() -> bool:
	var bot_id: int = get_container().bot_id
	if bot_id != author_id:
		push_error("Can not delete a message that was not sent by the client")
		await Awaiter.submit()
		return false
	return _delete()

func get_class() -> String:
	return "Message"

func _delete() -> bool:
	return await get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_message", [channel_id, self.id]
	)

func _clone_data() -> Array:
	return [{
		id = self.id,
		channel_id = self.channel_id,
		author_id = self.author_id,
		timestamp = self.timestamp,
		type = self.type,
		reactions = self.reactions,
		nonce = self.nonce,
		flags = self.flags.flags,
		sticker_items = self.sticker_items.duplicate(),
		interaction = self.interaction,
		is_pinned = self.is_pinned,
		content = self.content,
		edited_timestamp = self.edited_timestamp,
		mentions = self.mentions.duplicate(),
		channel_mentions = self.channel_mentions.duplicate(),
		attachments = self.attachments.duplicate(),
		embeds = self.embeds.duplicate(),
		components = self.components.duplicate(),
		message_reference = self.message_reference,
		referenced_message_id = self.referenced_message_id
	}]

func _update(data: Dictionary) -> void:
	super(data)
	is_pinned = data.get("is_pinned", is_pinned)
	content = data.get("content", content)
	edited_timestamp = data.get("edited_timestamp", edited_timestamp)
	mentions = data.get("mentions", mentions)
	channel_mentions = data.get("channel_mentions", channel_mentions)
	attachments = data.get("attachments", attachments)
	embeds = data.get("embeds", embeds)
	components = data.get("components", components)
	if not flags:
		flags = BitFlag.new(Flags)
	flags.flags = data.get("flags", flags.flags)

#func __set(_value):
#	pass
