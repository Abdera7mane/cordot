class_name GatewayOpcodes

enum Gateway {
	DISPATCH              = 0,
	HEARTBEAT             = 1,
	IDENTIFY              = 2,
	PRESENCE_UPDATE       = 3,
	VOICE_STATE_UPDATE    = 4,
	RESUME                = 6,
	RECONNECT             = 7,
	REQUEST_GUILD_MEMBERS = 8,
	INVALID_SESSION       = 9,
	HELLO                 = 10,
	HEARTBEAT_ACK         = 11
}

enum Voice {
	IDENTIFY,
	SELECT_PROTOCOL,
	READY,
	HEARTBEAT,
	SESSION_DESCRIPTION,
	SPEAKING,
	HEARTBEAT_ACK,
	RESUME,
	HELLO,
	RESUMED,
	CLIENT_DISCONNECT = 13
}
