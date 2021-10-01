class_name Message extends DiscordEntity

# warning-ignore:unused_signal
signal updated()
# warning-ignore:unused_signal
signal on_delete()
# warning-ignore:unused_signal
signal reaction_added(emoji, user)
# warning-ignore:unused_signal
signal reaction_removed(emoji, user)
# warning-ignore:unused_signal
signal all_reactions_removed(emoji, user)
# warning-ignore:unused_signal
signal reaction_remove_emoji(emoji, user)

enum Type {
	DEFAULT,
	RECIPIENT_ADD,
	CAIL,
	CHANNEL_NAME_CHANGE
	CHANNEL_ICON_CHANGE
	CHANNEL_PINNED_MESSAGE,
	GUILD_PINNED_MESSAGE
	GUILD_MEMBER_ICON,
	USER_PREMIUM_GUILD_SUBSCRIPTION,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_1,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_2,
	USER_PREMIUM_GUILD_SUBSCRIPTION_TIER_3,
	CHANNEL_FOLLOW_ADD,
	GUILD_DISCOVERY_DISQUALIFIED           = 14,
	GUILD_DISCOVERY_REQUALIFIED            = 15,
	REPLY                                  = 19,
	APPLICATION_COMMAND                    = 20
}

enum Flags {
	NONE,
	CROSSPOSTED             = 1 << 0,
	IS_CROSSPOST            = 1 << 1,
	SUPPRESS_EMBEDS         = 1 << 2,
	SOURCE_MESSAGE_DELETED  = 1 << 3,
	URGENT                  = 1 << 4,
	HAS_THREAD              = 1 << 5,
	EPHEMERAL               = 1 << 6,
	LOADING                 = 1 << 7,
}

var channel_id: int                     setget __set
var channel: Channel                    setget __set
var author_id: int                      setget __set
var author: User                        setget __set
var timestamp: int                      setget __set
var type: int                           setget __set
var content: String                     setget __set
var edited_timestamp: int               setget __set
var mentions: Array                     setget __set
var attachments: Array                  setget __set
var embeds: Array                       setget __set
var reactions: Array                    setget __set
var nonce: String                       setget __set
var is_pinned: bool                     setget __set
var webhook_id: int                     setget __set
var webhook: Object                     setget __set
var activity: MessageActivity           setget __set
var application_id: int                 setget __set
var application: DiscordApplication     setget __set
var message_reference: MessageReference setget __set
var flags: int                          setget __set
var referenced_message: Message         setget __set
var interaction: DiscordInteraction     setget __set
var components: Array                   setget __set
var sticker_items: Array                setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	channel_id = data["channel_id"]
	author_id = data["author_id"]
	timestamp = data["timestamp"]
	type = data["type"]
	reactions = data.get("recations", [])
	nonce = data.get("nonce", "")
	webhook_id = data.get("webhook_id", 0)
	flags = data.get("flags", Flags.NONE)
	sticker_items = data.get("stickers", [])
	interaction = data.get("interaction")
	self._update(data)
	
# warning-ignore:return_value_discarded
	self.connect("reaction_added", self, "_on_reaction_added")
	
func _update(data: Dictionary) -> void:
	is_pinned = data.get("is_pinned", is_pinned)
	content = data.get("content", content)
	edited_timestamp = data.get("edited_timestamp", edited_timestamp)
	mentions = data.get("mentions", mentions)
	attachments = data.get("attachments", attachments)
	embeds = data.get("embeds", embeds)
	components = data.get("components", components)

func _add_reaction(emoji: Emoji, _user: User):
	self.reactions.append(emoji)
	self.emit_signal("reaction_added", emoji, _user)

func get_class() -> String:
	return "Message"

func __set(_value):
	.__set(_value)

class MessageReference:
	var message_id: int          setget __set
	var channel_id: int          setget __set
	var guild_id: int            setget __set
	var fail_if_not_exists: bool setget __set
	
	func _init(data: Dictionary) -> void:
		message_id = data.message_id
		channel_id = data.channel_id
		guild_id = data.guild_id
		fail_if_not_exists = data.fail_if_not_exists
	
	func get_class() -> String:
		return "MessageReference"
	
	func __set(_value):
		pass
