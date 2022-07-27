class_name VoiceState extends DiscordEntity


var guild_id: int
var guild: Guild:
	get = get_guild
var channel_id: int
var channel: GuildVoiceChannel:
	get = get_channel
var user: User:
	get = get_user
var member: Member:
	get = get_member
var session_id: String
var is_deafened: bool
var is_muted: bool
var self_deaf: bool
var self_mute: bool
var self_stream: bool
var self_video: bool
var suppress: bool
var request_to_speak: int

func _init(data: Dictionary) -> void:
	super(data["user_id"])
	guild_id = data["guild_id"]
	member = data.get("member")
	_update(data)

func get_guild() -> Guild:
	return get_container().guilds.get(guild_id)

func get_channel() -> GuildVoiceChannel:
	return self.guild.get_channel(channel_id) as GuildVoiceChannel

func get_user() -> User:
	return get_container().users.get(self.id)

func get_class() -> String:
	return "Guild.VoiceState"

func get_member() -> Member:
	return member if member else self.guild.get_member(self.id)

func _update(data: Dictionary) -> void:
	channel_id = data.get("channel_id", channel_id)
	session_id = data.get("session_id", session_id)
	is_deafened = data.get("deaf", is_deafened)
	is_muted = data.get("mute", is_muted)
	self_deaf = data.get("self_deaf", self_deaf)
	self_mute = data.get("self_mute", self_mute)
	self_stream = data.get("self_stream", self_stream)
	self_video = data.get("self_video", self_video)
	suppress = data.get("suppress", suppress)
	request_to_speak = data.get("request_to_speak", request_to_speak)

func _clone_data() -> Array:
	return [{
		user_id = self.id,
		guild_id = self.guild_id,
		member = member,
		channel_id = self.channel_id,
		session_id = self.session_id,
		is_deafened = self.is_deafened,
		is_muted = self.is_muted,
		self_deaf = self.self_deaf,
		self_mute = self.self_mute,
		self_stream = self.self_stream,
		self_video = self.self_video,
		suppress = self.suppress,
		request_to_speak = self.request_to_speak
	}]
