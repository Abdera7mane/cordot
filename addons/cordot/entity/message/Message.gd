# Represents a message sent in a channel within Discord.
class_name Message extends TextChannel.BaseMessage

# Message types.
enum Type {
	DEFAULT,
	RECIPIENT_ADD,
	RECIPIENT_REMOVE,
	CALL,
	CHANNEL_NAME_CHANGE
	CHANNEL_ICON_CHANGE
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

# Message flags.
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

# The author's id of this message.
var author_id: int                      setget __set

# The author of this message.
var author: User                        setget __set, get_author

# When this message was sent in unix time in seconds.
var timestamp: int                      setget __set

# Type of message.
var type: int                           setget __set

# Contents of the message.
var content: String                     setget __set

# When this message was edited (or `0` if never).
var edited_timestamp: int               setget __set

# List of `User`s mentioned in the message.
var mentions: Array                     setget __set

# List of `ChannelMention` objects in this message.
var channel_mentions: Array             setget __set 

# List of `MessageAttachment` objects.
var attachments: Array                  setget __set

# List of `MessageEmbed` objects.
var embeds: Array                       setget __set

# List of `MessageReaction` objects attached to the message.
var reactions: Array                    setget __set

var nonce: String                       setget __set

# Whether this message is pinned.
var is_pinned: bool                     setget __set

# Webhook's id if the message is from a webhook.
var webhook_id: int                     setget __set

# Webhook object reference if the message is fro ma webhook.
var webhook: DiscordWebhook             setget __set

# Present with Rich Presence-related chat embeds.
var activity: MessageActivity           setget __set

# Present with Rich Presence-related chat embeds.
var application: DiscordApplication     setget __set

# The id of the application, if  the message is an interaction
# or application-owned webhook.
var application_id: int                 setget __set

# The message `Flags`.
var flags: BitFlag                      setget __set

# Contains information on the referenced message such in replies and cross posts.
var message_reference: MessageReference setget __set

# The `reference_message` id.
var referenced_message_id: int          setget __set

# The message associated with the `message_reference`.
var referenced_message: Message         setget __set, get_referenced_message

var interaction: MessageInteraction     setget __set

# List of `MessageComponent` objects attached to the message.
var components: Array                   setget __set

# List of `MessageSticker` objects attached to the message.
var sticker_items: Array                setget __set

# doc-hide
func _init(data: Dictionary).(data) -> void:
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

# `author` getter.
func get_author() -> User:
	return get_container().users.get(author_id)

# `referenced_message` getter.
func get_referenced_message() -> Message:
	return get_container().messages.get(referenced_message_id)

# Edits the message, the messge author must be same bot user.
func edit() -> MessageEditAction:
	return MessageEditAction.new(get_rest(), channel_id, self.id)

# Fetches the message from Discord API.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func fetch() -> Message:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [channel_id, self.id]
	)

# Fetches the referenced message if there is any from Discord API.
#
# doc-qualifiers:coroutine
# doc-override-return:Message
func fetch_referenced_message() -> Message:
	return get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_message", [channel_id, referenced_message_id]
	) if referenced_message_id != 0 else Awaiter.submit()

# Create a reply to this message.
func reply(with_content: String = "") -> MessageCreateAction:
	return MessageCreateAction.new(
		get_rest(), channel_id
	).set_content(with_content).reply_to(self.id)

# Reacts to the message with `emoji`.
# Requires bot to have `ADD_REACTIONS` permission in guild channels.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func react(emoji: Emoji) -> bool:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"create_reaction", [channel_id, self.id, emoji]
	), "completed")

# Removes the `emoji` reaction from the message.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func unreact(emoji: Emoji) -> bool:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_own_reaction", [channel_id, self.id, emoji]
	), "completed")

# Removes a user reactions from the message.
# Requires the bot to have `MANAGE_MESSAGES` permission.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func remove_reaction(user_id: int, emoji: Emoji) -> bool:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_user_reaction", [channel_id, self.id, emoji, user_id]
	), "completed")

# Fetches the `emoji` reactions from Discord API.
# Requires the bot to have `MANAGE_MESSAGES` permission
#
# doc-qualifiers:coroutine
# doc-override-return:Array
func fetch_reactions(emoji: Emoji, after: int = 0, limit: int = 25) -> Array:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_reactions", [channel_id, self.id, emoji, after, limit]
	), "completed")

# Removes all reactions from the message.
# Requires the bot to have `MANAGE_MESSAGES` permission
#
# doc-qualifiers:coroutine
# doc-override-return:void
func clear_all_reactions() -> void:
	yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_all_reactions", [channel_id, self.id]
	), "completed")

# Removes all `emoji` reactions from the message.
#
# doc-qualifiers:coroutine
# doc-override-return:void
func clear_emoji_reactions(emoji: Emoji) -> void:
	yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_emoji_reactions", [channel_id, self.id, emoji]
	), "completed")

# Deletes the message if the author is the same bot user. If the message
# is inside a guild channel, the bot must have `MANAGE_MESSAGES` permission
# to delete other members messages.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func delete() -> bool:
	var bot_id: int = get_container().bot_id
	if bot_id != author_id:
		push_error("Can not delete a message that was not sent by the client")
		yield(Awaiter.submit(), "completed")
		return false
	return _delete()

# doc-hide
func get_class() -> String:
	return "Message"

func _delete() -> bool:
	return yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"delete_message", [channel_id, self.id]
	), "completed")

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
	._update(data)
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

func __set(_value):
	pass
