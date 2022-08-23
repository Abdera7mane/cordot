# Discord REST API constants
class_name DiscordREST

# Discord REST API types.
enum {
	APPLICATION,
	CHANNEL,
	GUILD,
	INTERACTION,
	USER,
	WEBHOOK
}

# Discord CDN file formats.
const CDN_FILE_FORMATS: PoolStringArray = PoolStringArray([
	"jpg", "jpeg",
	"png",
	"webp",
	"gif",
	"json"
])

# Discord REST API endpoints.
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
	MESSAGE_REACTION = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}",
	MESSAGE_OWN_REACTION = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}/@me",
	MESSAGE_USER_REACTION = "/channels/{channel_id}/messages/{message_id}/reactions/{emoji}/{user_id}",
	MESSAGE_REACTIONS = "/channels/{channel_id}/messages/{message_id}/reactions",
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
	GUILDS = "/guilds",
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
	GUILD_ROLES = "/guilds/{guild_id}/roles",
	GUILD_ROLE = "/guilds/{guild_id}/roles/{role_id}",
	GUILD_PRUNE = "/guilds/{guild_id}/prune",
	GUILD_VOICE_REGIONS = "/guilds/{guild_id}/regions",
	GUILD_INVITES = "/guilds/{guild_id}/invites",
	GUILD_INTEGRATIONS = "/guilds/{guild_id}/integrations",
	GUILD_INTEGRATION = "/guilds/{guild_id}/integrations/{integration_id}",
	GUILD_INTEGRATION_SYNC = "/guilds/{guild_id}/integrations/{integration_id}/sync",
	GUILD_WIDGET = "/guilds/{guild_id}/widget.json",
	GUILD_WIDGET_SETTINGS = "/guilds/{guild_id}/widget",
	GUILD_WIDGET_IMAGE = "/guilds/{guild_id}/widget.png",
	GUILD_VANITY_URL = "/guilds/{guild_id}/vanity-url",
	GUILD_WELCOME_SCREEN = "/guilds/{guild_id}/welcome-screen",
	GUILD_TEMPLATES = "/guilds/{guild_id}/templates",
	GUILD_TEMPLATE = "/guilds/templates/{template_code}",
	GUILD_TEMPLATE_FROM_GUILD = "/guilds/{guild_id}/templates/{template_code}",
	GUILD_AUDIT_LOG = "/guilds/{guild_id}/audit-logs",
	GUILD_SCHEDULED_EVENTS = "/guilds/{guild_id}/scheduled-events",
	GUILD_SCHEDULED_EVENT = "/guilds/{guild_id}/scheduled-events/{event_id}",
	CURRENT_MEMBER = "/guilds/{guild_id}/members/@me",
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
	WEBHOOK_GITHUB = "/webhooks/{webhook_id}/{webhook_token}/github",
	
	# CDN endpoints
	CUSTOM_EMOJI = "/emojis/{emoji_id}",
	GUILD_ICON = "/icons/{guild_id}/{hash}",
	GUILD_SPLASH = "/splashes/{guild_id}/{hash}",
	GUILD_DISCOVERY_SPLASH = "/discovery-splashes/{guild_id}/{hash}",
	BANNER = "/banners/{entity_id}/{hash}",
	DEFAULT_USER_AVATAR = "/embed/avatars/{discriminator}",
	USER_AVATAR = "/avatars/{user_id}/{hash}",
	GUILD_MEMBER_AVATAR = "/guilds/{guild_id}/users/{user_id}/avatars/{hash}",
	APPLICATION_ICON = "/app-icons/{application_id}/{hash}",
	APPLICATION_ASSET = "/app-assets/{application_id}/{asset_id}",
	ACHIEVEMENT_ID = "/app-assets/{application_id}/achievements/{achievement_id}/icons/{hash}",
	STICKER_PACK_BANNER = "/app-assets/710982414301790216/store/{asset_id}",
	TEAM_ICON = "/team-icons/{team_id}/{hash}",
	STICKER_RESOURCE = "/stickers/{sticker_id}",
	ROLE_ICON = "/role-icons/{role_id}/{hash}",
	
	# Application endpoints
	APPLICATION_COMMANDS = "/applications/{application_id}/commands",
	APPLICATION_COMMAND = "/applications/{application_id}/commands/{command_id}",
	GUILD_APPLICATION_COMMANDS = "/applications/{application_id}/guilds/{guild_id}/commands",
	GUILD_APPLICATION_COMMAND = "/applications/{application_id}/guilds/{guild_id}/commands/{command_id}",
	
	# Interaction endpoints
	INTERACTION_CALLBACK = "/interactions/{interaction_id}/{token}/callback",
	INTERACTION_ORIGINAL_RESPONSE = "/webhooks/{application_id}/{token}/messages/@original",
	CREATE_FOLLOWUP_MESSAGE = "/webhooks/{application_id}/{token}",
	FOLLOWUP_MESSAGE = "/webhooks/{application_id}/{token}/messages/{message_id}"
}
