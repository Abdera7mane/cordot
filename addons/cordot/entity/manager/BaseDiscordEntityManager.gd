class_name BaseDiscordEntityManager

enum CacheFlags {
	GUILD_MEMBERS = 1 << 0,
	MESSAGES      = 1 << 1,
	PRESENCES     = 1 << 2
}

var container: Dictionary = DiscordEntity.DEFAULT_CONTAINER.duplicate()

var application_manager: BaseDiscordApplicationManager
var channel_manager: BaseChannelManager
var emoji_manager: BaseEmojiManager
var guild_manager: BaseGuildManager
var interaction_manager: BaseDiscordInteractionManager
var message_manager: BaseMessageManager
var user_manager: BaseUserManager

var rest_mediator: DiscordRESTMediator
var cache_flags: BitFlag = BitFlag.new(CacheFlags)

var max_messages: int = 1000

func cache_flags_from_intents(intents: BitFlag) -> void:
	cache_flags.GUILD_MEMBERS = intents.GUILD_MEMBERS
	cache_flags.MESSAGES = intents.GUILD_MESSAGES or intents.DIRECT_MESSAGES 
	cache_flags.PRESENCES = intents.GUILD_PRESENCES 

func reset() -> void:
	container.applications.clear()
	container.channels.clear()
	container.guilds.clear()
	container.messages.clear()
	container.presences.clear()
	container.users.clear()
	container.teams.clear()
	container.bot_id = 0

func get_or_construct_channel(data: Dictionary, cache: bool = true) -> Channel:
	var id: int = data["id"] as int
	var channel: Channel = get_channel(id)
		
	if channel:
		channel_manager.update_channel(channel, data)
	
	else:
		channel = channel_manager.construct_channel(data)
		if cache:
			put_channel(channel)
	
	return channel

func get_or_construct_emoji(data: Dictionary) -> Emoji:
	return self.emoji_manager.construct_emoji(data)

func get_or_construct_guild(data: Dictionary, cache: bool = true) -> Guild:
	var id: int = data["id"] as int
	var guild: Guild = get_guild(id)
	
	if guild:
		guild_manager.update_guild(guild, data)
	
	else:
		guild = guild_manager.construct_guild(data)
		if cache:
			put_guild(guild)
	
	return guild

func get_or_construct_guild_member(data: Dictionary, cache: bool = false) -> Guild.Member:
	var id: int = data["user"]["id"] as int
	var guild: Guild = get_guild(data["guild_id"] as int)
	var member: Guild.Member
	if guild:
		member = guild.get_member(id)
	
	if member:
		guild_manager.update_guild_member(member, data)
	
	else:
		member = guild_manager.construct_guild_member(data)
		if cache_flags.GUILD_MEMBERS and cache and guild:
			guild._members[member.id] = member
	
	return member

func get_or_construct_message(data: Dictionary, cache: bool = false) -> Message:
	var id: int = data["id"] as int
	var message: Message = get_message(id)
	
	if message:
		message_manager.update_message(message, data)
	
	else:
		message = message_manager.construct_message(data)
		if cache_flags.MESSAGES and cache:
			put_message(message)
	
	return message

func get_or_construct_user(data: Dictionary, cache: bool = true) -> User:
	var id: int = data["id"] as int
	var user: User = get_user(id)
	
	if user:
		user_manager.update_user(user, data)
	
	else:
		user = user_manager.construct_user(data)
		if cache:
			put_user(user)
	
	return user

func get_or_construct_presence(data: Dictionary, cache: bool = false) -> Presence:
	var id: int = data["user"]["id"] as int
	var presence: Presence = get_presence(id)
	
	if presence:
		user_manager.update_presence(presence, data)
	
	else:
		presence = user_manager.construct_presence(data)
		if cache_flags.PRESENCES and cache:
			put_pesence(presence)
	
	return presence

func get_or_construct_voice_state(data: Dictionary) -> Guild.VoiceState:
	var id: int = data["user_id"] as int
	var guild: Guild = get_guild(data["guild_id"] as int)
	var state: Guild.VoiceState
	if guild:
		state = guild.voice_states.get(id)
	
	if state:
		guild_manager.update_voice_state(state, data)
	
	else:
		state = guild_manager.construct_voice_state(data)
	
	return state

func get_self() -> User:
	return get_user(self.container.bot_id)

func get_user(id: int) -> User:
	return self.container.users.get(id)

func get_presence(id: int) -> Presence:
	return self.container.presences.get(id)
 
func get_guild(id: int) -> Guild:
	return self.container.guilds.get(id)

func get_channel(id: int) -> Channel:
	return self.container.channels.get(id)

func get_message(id: int) -> Message:
	return self.container.messages.get(id)

func get_application(id: int) -> DiscordApplication:
	return self.container.applications.get(id)

func get_team(id: int) -> DiscordTeam:
	return self.container.teams.get(id)

func get_users() -> Array:
	return self.container.users.values()

func get_presences() -> Array:
	return self.container.presences.values()

func get_guilds() -> Array:
	return self.container.guilds.values()

func get_channels() -> Array:
	return self.container.channels.values()

func get_messages() -> Array:
	return self.container.messages.values()

func get_applications() -> Array:
	return self.container.applications.values()

func get_teams() -> Array:
	return self.container.teams.values()

func put_user(user: User) -> void:
	if user:
		self.container.users[user.id] = user

func put_guild(guild: Guild) -> void:
	if guild:
		self.container.guilds[guild.id] = guild

func put_channel(channel: Channel) -> void:
	if channel:
		self.container.channels[channel.id] = channel

func put_pesence(presence: Presence) -> void:
	if presence:
		self.container.presences[presence.id] = presence

func put_message(message: Message) -> void:
	if message:
		var messages: Dictionary = container.messages
		var total_messages: int = messages.size()
		if total_messages * max_messages != 0 and total_messages == max_messages:
			var oldest_id: int = messages.keys()[0]
			remove_message(oldest_id)
		self.container.messages[message.id] = message

func remove_user(id: int) -> void:
	self.container.users.erase(id)

func remove_guild(id: int) -> void:
	var guild: Guild = self.container.guilds.erase(id)
	if guild:
		for channel_id in guild.channels_ids:
			self.remove_channel(channel_id)

func remove_channel(id: int) -> void:
	self.container.channels.erase(id)

func remove_pesence(id: int) -> void:
	self.container.presences.erase(id)

func remove_message(id: int) -> void:
	self.container.messages.erase(id)

func get_class() -> String:
	return "BaseDiscordEntityManager"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
