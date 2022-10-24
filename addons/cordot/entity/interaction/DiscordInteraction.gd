# Abstraction of Discord interactions such as Application Commands
# and Message Components. An interaction remains valid for **15 minutes**.
class_name DiscordInteraction extends DiscordEntity

# Interaction types.
enum Type {
	PING                = 1,
	APPLICATION_COMMAND = 2,
	MESSAGE_COMPONENT   = 3,
	AUTOCOMPLETE        = 4,
	MODAL_SUBMIT        = 5
}

# Interaction callback types.
enum Callback {
	PONG                     = 1,
	CHANNEL_MESSAGE          = 4,
	DEFERRED_CHANNEL_MESSAGE = 5,
	DEFERRED_UPDATE_MESSAGE  = 6,
	UPDATE_MESSAGE           = 7,
	AUTOCOMPLETE_RESULT      = 8,
	MODAL                    = 9,
}

# Id of the Discord application this interaction is for.
var application_id: int             setget __set

# Reference to the Discord application.
var application: DiscordApplication setget __set, get_application

# Type of interaction.
var type: int                       setget __set

# The guild id that the interaction was sent from.
var guild_id: int                   setget __set

# Reference to the guild that the interaction was sent from.
var guild: Guild                    setget __set, get_guild

# The channel id that the interaction was sent from.
var channel_id: int                 setget __set
 
# Reference to the channel that the interaction was sent from.
var channel: TextChannel            setget __set, get_channel

# Guild member who invoked the interaction if inside a guild.
var member: Guild.Member            setget __set

# User id of who invoked the interaction.
var user_id: int                    setget __set, get_user_id

# Reference to the user who invoked the interaction.
var user: User                      setget __set, get_user

# Continuation token for responding to the interaction.
var token: String                   setget __set

# Discord Interaction API version.
var version: int                    setget __set

# Set of permissions the app or bot has within the channel the interaction
# was sent from.
var app_permissions: BitFlag        setget __set

# Selected language of the invoking user.
var locale: String                  setget __set

# Guild's preferred locale, if invoked in a guild.
var guild_locale: String            setget __set

# doc-hide
func _init(data: Dictionary).(data["id"]) -> void:
	application_id = data["application_id"]
	type = data["type"]
	guild_id = data.get("guild_id", 0)
	channel_id = data.get("channel_id", 0)
	member = data.get("member")
	user_id = data["user_id"]
	user = data["user"]
	token = data["token"]
	version = data["version"]
	locale = data.get("locale", "")
	guild_locale = data.get("guild_locale", "")
	if data.has("app_permissions"):
		app_permissions = BitFlag.new(Permissions.get_script_constant_map())
		app_permissions.flags = data["app_permissions"]

# `application` getter.
func get_application() -> DiscordApplication:
	return get_container().applications.get(application_id)

# `guild` getter.
func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

# `channel` getter.
func get_channel() -> TextChannel:
	var _channel: Channel = get_container().channels.get(channel_id)
	if not _channel and self.guild:
		_channel = self.guild.get_thread(channel_id)
	if _channel is Guild.GuildVoiceChannel:
		_channel = _channel.text_channel
	return _channel as TextChannel

# `member` getter.
func get_member() -> Guild.Member:
	return member

# `user_id` getter.
func get_user_id() -> int:
	return user_id if not member else member.id

# `user` getter.
func get_user() -> User:
	return user if user else member.user

# Whether this is a `DiscordApplicationCommandInteraction`.
func is_command() -> bool:
	return type == Type.APPLICATION_COMMAND

# Whether this is a `DiscordAutocompleteInteraction`.
func is_autocomplete() -> bool:
	return type == Type.AUTOCOMPLETE

# Whether this is a `DiscordMessageComponentInteraction`.
func is_message_component() -> bool:
	return type == Type.MESSAGE_COMPONENT

# Whether this is a `DiscordModalSubmit`.
func is_modal_submit() -> bool:
	return type == Type.MODAL_SUBMIT

# Whether the interaction was invoked in a guild.
func in_guild() -> bool:
	return guild_id != 0

# Fetches the `user`.
#
# doc-qualifiers:coroutine
# doc-override-return:User
func fetch_user() -> User:
	user = yield(get_rest().request_async(
		DiscordREST.USER,
		"get_user", [self.user_id]
	), "completed")
	return user

# Fetches the `channel`.
#
# doc-qualifiers:coroutine
# doc-override-return:TextChannel
func fetch_channel() -> TextChannel:
	channel = yield(get_rest().request_async(
		DiscordREST.CHANNEL,
		"get_channel", [channel_id]
	) if channel_id else Awaiter.submit(), "completed")
	return channel

# Fetches the `member` if the interaction was invoked in a guild.
#
# doc-qualifiers:coroutine
# doc-override-return:Member
func fetch_member() -> Guild.Member:
	member = yield(get_rest().request_async(
		DiscordREST.USER,
		"get_guild_member", [guild_id, self.user_id]
	) if in_guild() else Awaiter.submit(), "completed")
	return member

# Fetches the `guild` if the interaction was invoked in a guild.
#
# doc-qualifiers:coroutine
# doc-override-return:Guild
func fetch_guild() -> Guild:
	guild = yield(get_rest().request_async(
		DiscordREST.GUILD,
		"get_guild", [guild_id]
	) if in_guild() else Awaiter.submit(), "completed")
	return guild

# doc-hide
func get_class() -> String:
	return "DiscordInteraction"

func __set(_value) -> void:
	pass
