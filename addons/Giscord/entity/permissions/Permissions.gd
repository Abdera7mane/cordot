class_name Permissions

enum {
	CREATE_INSTANT_INVITE      = 1 << 0,
	KICK_MEMBERS               = 1 << 1,
	BAN_MEMBERS                = 1 << 2,
	ADMINISTRATOR              = 1 << 3,
	MANAGE_CHANNELS            = 1 << 4,
	MANAGE_GUILD               = 1 << 5,
	ADD_REACTIONS              = 1 << 6,
	VIEW_AUDIT_LOG             = 1 << 7,
	PRIORITY_SPEAKER           = 1 << 8,
	STREAM                     = 1 << 9,
	VIEW_CHANNEL               = 1 << 10,
	SEND_MESSAGES              = 1 << 11,
	SEND_TTS_MESSAGES          = 1 << 12,
	MANAGE_MESSAGES            = 1 << 13,
	EMBED_LINKS                = 1 << 14,
	ATTACH_FILES               = 1 << 15,
	READ_MESSAGE_HISTORY       = 1 << 16,
	MENTION_EVERYONE           = 1 << 17,
	USE_EXTERNAL_EMOJIS        = 1 << 18,
	VIEW_GUILD_INSIGHTS        = 1 << 19,
	CONNECT                    = 1 << 20,
	SPEAK                      = 1 << 21,
	MUTE_MEMBERS               = 1 << 22,
	DEAFEN_MEMBERS             = 1 << 23,
	MOVE_MEMBERS               = 1 << 24,
	USE_VAD                    = 1 << 25,
	CHANGE_NICKNAME            = 1 << 26,
	MANAGE_NICKNAMES           = 1 << 27,
	MANAGE_ROLES               = 1 << 28,
	MANAGE_WEBHOOKS            = 1 << 29,
	MANAGE_EMOJIS_AND_STICKERS = 1 << 30,
	USE_APPLICATION_COMMANDS   = 1 << 31,
	REQUEST_TO_SPEAK           = 1 << 32,
	MANAGE_THREADS             = 1 << 34,
	USE_PUBLIC_THREADS         = 1 << 35,
	USE_PRIVATE_THREADS        = 1 << 36,
	USE_EXTERNAL_STICKERS      = 1 << 37
}

const ALL: int = (CREATE_INSTANT_INVITE | KICK_MEMBERS | BAN_MEMBERS
				| ADMINISTRATOR | MANAGE_CHANNELS | MANAGE_GUILD | ADD_REACTIONS
				| VIEW_AUDIT_LOG | PRIORITY_SPEAKER | STREAM | VIEW_CHANNEL
				| SEND_MESSAGES | SEND_TTS_MESSAGES | MANAGE_MESSAGES
				| EMBED_LINKS | ATTACH_FILES | READ_MESSAGE_HISTORY
				| MENTION_EVERYONE | USE_EXTERNAL_EMOJIS | VIEW_GUILD_INSIGHTS
				| CONNECT | SPEAK | MUTE_MEMBERS | DEAFEN_MEMBERS | MOVE_MEMBERS
				| USE_VAD | CHANGE_NICKNAME | MANAGE_NICKNAMES | MANAGE_ROLES
				| MANAGE_WEBHOOKS | MANAGE_EMOJIS_AND_STICKERS
				| USE_APPLICATION_COMMANDS | REQUEST_TO_SPEAK | MANAGE_THREADS
				| USE_PUBLIC_THREADS | USE_PRIVATE_THREADS | USE_EXTERNAL_STICKERS)

const d = sin(5)
