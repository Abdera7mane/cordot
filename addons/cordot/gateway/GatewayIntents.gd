# Gateway intents specifies the group of events that are sent by Discord to the
# client.
class_name GatewayIntents

enum {

	# Enabled events:
	# - `guild_created`
	# - `guild_updated`
	# - `guild_deleted`
	# - `guild_role_created`
	# - `guild_role_updated`
	# - `guild_role_deleted`
	# - `channel_created`
	# - `channel_updated`
	# - `channel_deleted`
	# - `channel_pins_updated`
	# - `thread_created`
	# - `thread_updated`
	# - `thread_deleted`
	# - `thread_list_sync`
	# - `thread_member_updated`
	# - `thread_members_updated`
	# - `stage_instance_created`
	# - `stage_instance_updated`
	# - `stage_instance_deleted`
	GUILDS                   = 1 << 0,

	# Enabled events:
	# - `member_joined`
	# - `guild_member_updated`
	# - `member_left`
	# - `thread_members_update`
	GUILD_MEMBERS            = 1 << 1,

	# Enabled events:
	# - `guild_ban_added`
	# - `guild_ban_removed`
	GUILD_BANS               = 1 << 2,

	# Enabled events:
	# - `guild_emojis_updated`
	# - `guild_stickers_updated`
	GUILD_EMOJIS             = 1 << 3,

	# Enabled events:
	# - `guild_integrations_updated`
	# - `integration_created`
	# - `integration_updated`
	# - `integration_deleted`
	GUILD_INTEGRATIONS       = 1 << 4,

	# Enabled events:
	# - `webhooks_updated`
	GUILD_WEBHOOKS           = 1 << 5,

	# Enabled events:
	# - `invite_created`
	# - `invite_deleted`
	GUILD_INVITES            = 1 << 6,

	# Enabled events:
	# - `voice_state_updated`
	GUILD_VOICE_STATES       = 1 << 7,

	# Enabled events:
	# - `presence_updated`
	GUILD_PRESENCES          = 1 << 8,

	# Enabled events:
	# - `message_sent` 
	# - `message_updated`
	# - `message_deleted`
	# - `message_bulk_deleted`
	GUILD_MESSAGES           = 1 << 9,

	# Enabled events:
	# - `reaction_added`
	# - `reaction_removed`
	# - `reactions_cleared`
	# - `reactions_cleared_emoji`
	GUILD_MESSAGE_REACTIONS  = 1 << 10,

	# Enabled events:
	# - `typing_started`
	GUILD_MESSAGE_TYPING     = 1 << 11,

	# Enabled events:
	# - `message_sent` 
	# - `message_updated`
	# - `message_deleted`
	# - `channel_pins_updated`
	DIRECT_MESSAGES          = 1 << 12,

	# Enabled events:
	# - `reaction_added`
	# - `reaction_removed`
	# - `reactions_cleared`
	# - `reactions_cleared_emoji`
	DIRECT_MESSAGE_REACTIONS = 1 << 13,

	# Enabled events:
	# - `typing_started`
	DIRECT_MESSAGE_TYPING    = 1 << 14
}

# Privileged intents.
const PRIVILEGED = GUILD_PRESENCES | GUILD_MEMBERS

# Unprivileged intents.
const UNPRIVILEGED = (GUILDS | GUILD_BANS | GUILD_EMOJIS | GUILD_INTEGRATIONS
					| GUILD_WEBHOOKS| GUILD_INVITES | GUILD_VOICE_STATES
					| GUILD_MESSAGES | GUILD_MESSAGE_REACTIONS
					| GUILD_MESSAGE_TYPING | DIRECT_MESSAGES
					| DIRECT_MESSAGE_REACTIONS | DIRECT_MESSAGE_TYPING)

# All intents.
const ALL = PRIVILEGED | UNPRIVILEGED
