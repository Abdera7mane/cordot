class_name DiscordRESTAPI

const ENDPOINTS: Dictionary = {
	INVITE = "/invites/{invite_code}",
	STICKER = "/stickers/{sticker_id}",
	STICKER_PACKS = "/sticker-packs",
	STAGE_INSTANCES = "/stage-instances",
	STAGE_INSTANCE = "/stage-instances/{channel_id}",
	VOICE_REGIONS = "/voice/regions",
	
	# Channel endpoints
	CHANNEL = "/channels/{channel_id}",
	CHANNEL_MESSAGE = "/channels/{channel_id}/messages/{message_id}",
	CHANNEL_MESSAGES = "/channels/{channel_id}/messages",
	CHANNEL_PERMISSIONS = "/channels/{channel_id}/permissions/{overwrite_id}",
	CHANNEL_INVITES = "/channels/{channel_id}/invites",
	CHANNEL_FOLLOW = "/channels/{channel_id}/followers",
	CHANNEL_TYPING = "/channels/{channel_id}/typing",
	CHANNEL_PINS = "/channels/{channel_id}/pins",
	CHANNEL_PIN = "/channels/{channel_id}/pins/{message_id}",
	CHANNEL_RECIPIENT = "/channels/{channel_id}/pins/recipients/{user_id}",
	CHANNEL_WEBHOOKS = "/channels/{channel_id}/webhooks",
	CROSSPOST_MESSAGE = "/channels/{channel_id}/messages/{message_id}/crosspost",
	MESSAGE_REACTIONS = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}",
	MESSAGE_REACTION = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}/@me",
	MESSAGE_USER_REACTION = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}/{user_id}",
	MESSAGE_ALL_REACTIONS = "/channels/{channel_id}/messages/{message_id}/reactions",
	MESSAGE_BULK_DELETE = "/channels/{channel_id}/messages/bulk-delete",
	THREAD_WITH_MESSAGE = "/channels/{channel_id}/messages/{message_id}/threads",
	THREAD_WITHOUT_MESSAGE = "/channels/{channel_id}/threads",
	THREAD_CURRENT_MEMBER = "/channels/{channel_id}/thread-members/@me",
	THREAD_MEMBERS = "/channels/{channel_id}/thread-members",
	THREAD_MEMBER = "/channels/{channel_id}/thread-members/{user_id}",
	ACTIVE_THREADS = "/channels/{channel_id}/threads/active",
	PUBLIC_ARCHIVED_THREADS = "/channels/{channel_id}/threads/archived/public",
	PRIVATE_ARCHIVED_THREADS = "/channels/{channel_id}/threads/archived/private",
	JOINED_PRIVATE_ARCHIVED_THREADS = "/channels/{channel_id}/users/@me/threads/archived/private",
	
	# Guild endpoints
	GUILDs = "/guilds",
	GUILD = "/guilds/{guild_id}",
	GUILD_PREVIEW = "/guilds/{guild_id}/preview",
	GUILD_CHANNELS = "/guilds/{guild_id}/channels",
	GUILD_EMOJIS = "/guilds/{guild_id}/emojis",
	GUILD_EMOJI = "/guilds/{guild_id}/emojis/{emoji_id}",
	GUILD_STICKERS = "/guilds/{guild_id}/stickers",
	GUILD_STICKER = "/guilds/{guild_id}/stickers/{stickers_id}",
	GUILD_WEBHOOKS = "/guilds/{guild_id}/webhooks",
	GUILD_ACTIVE_THREADS = "/guilds/{guild_id}/threads/active",
	GUILD_MEMBERS = "/guilds/{guild_id}/members",
	GUILD_MEMBER = "/guilds/{guild_id}/members/{user_id}",
	GUILD_MEMBERS_SEARCH = "/guilds/{guild_id}/members/search",
	GUILD_MEMBER_ROLE = "/guilds/{guild_id}/members/{user_id}/roles/{role_id}",
	GUILD_BANS = "/guilds/{guild_id}/bans",
	GUILD_BAN = "/guilds/{guild_id}/bans/{user_id}",
	GUILD_PRUNE = "/guilds/{guild_id}/prune",
	GUILD_VOICE_REGIONS = "/guilds/{guild_id}/regions",
	GUILD_INVITES = "/guilds/{guild_id}/invites",
	GUILD_INTEGRATIONS = "/guilds/{guild_id}/integrations",
	GUILD_INTEGRATION = "/guilds/{guild_id}/integrations/{integration_id}",
	GUILD_INTEGRATION_SYNC = "/guilds/{guild_id}/integrations/{integration_id}/sync",
	GUILD_WIDGET = "/guilds/{guild_id}/widget.json",
	GUILD_WIDGET_SETTINGS = "/guilds/{guild_id}/widget",
	GUILD_WIDGET_IMAGE = "/guilds/{guild_id}/widget.png",
	GUILD_VANITY_URL = "/guilds/{guild_id}/vanity",
	GUILD_WELCOME_SCREEN = "/guilds/{guild_id}/welcome-screen",
	GUILD_TEMPLATES = "/guilds/{guild_id}/templates",
	GUILD_TEMPLATE = "/guilds/templates/{template_code}",
	GUILD_TEMPLATE_FROM_GUILD = "/guilds/{guild_id}/templates/{template_code}",
	GUILD_AUDIT_LOG = "/guilds/{guild_id}/audit-logs",
	GUILD_SCHEDULED_EVENTS = "/guilds/{guild_id}/scheduled-events",
	GUILD_SCHEDULED_EVENT = "/guilds/{guild_id}/scheduled-events/{event_id}",
	CURRENT_MEMBER = "/guilds/{guild_id}/members/@me",
	CURRENT_MEMBER_NICK = "/guilds/{guild_id}/members/@me/nick",
	CURRENT_MEMBER_VOICE_STATE = "/guilds/{guild_id}/voice-states/@me",
	MEMBER_VOICE_STATE = "/guilds/{guild_id}/voice-states/{user_id}",
	
	 # User endpoints
	CURRENT_USER = "/users/@me",
	CURRENT_USER_GUILDS = "/users/@me/guilds",
	CURRENT_USER_GUILD = "/users/@me/guilds/{guild_id}",
	CURRENT_USER_CONNECTIONS = "/users/@me/connections",
	USER = "/users/{user_id}",
	USER_DM = "/users/@me/channels",
	
	# Webhook endpoints
	WEBHOOK = "/webhooks/{webhook_id}",
	WEBHOOK_WITH_TOKEN = "/webhooks/{webhook_id}/{webhook_token}",
	WEBHOOK_MESSAGE = "/webhooks/{webhook_id}/{webhook_token}/messages/{message_id}",
	WEBHOOK_SLACK = "/webhooks/{webhook_id}/{webhook_token}/slack",
	WEBHOOK_GITHUB = "/webhooks/{webhook_id}/{webhook_token}/github"
}

var token: String                            setget __set
var requester: DiscordRESTRequester          setget __set
var rest_headers: PoolStringArray            setget __set
var entity_manager: BaseDiscordEntityManager setget __set

func _init(_token: String, _requester: DiscordRESTRequester, _entity_manager: BaseDiscordEntityManager) -> void:
	token = _token
	requester = _requester
	entity_manager = _entity_manager
		
	rest_headers = [
		HTTPHeaders.AUTHORIZATION.format({token = token}),
		HTTPHeaders.USER_AGENT.format({
			name = Discord.LIBRARY,
			url = Discord.LIBRARY_URL,
			version = Discord.LIBRARY_VERSION
		}),
	]

func rest_request(endpoint) -> RestRequest:
#	HTTPHeaders.CONTENT_TYPE.format({type = "application/json"})
	return RestRequest.new().url(rest_url(endpoint)).headers(rest_headers)
		

func __set(_value) -> void:
	pass

static func rest_url(endpoint: String) -> String:
	return Discord.REST_URL % Discord.REST_VERSION + endpoint

static func cdn_url(endpoint: String) -> String:
	return Discord.CDN_URL + endpoint
