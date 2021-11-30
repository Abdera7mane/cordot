class_name BaseDiscordEntityManager

var container: Dictionary = DiscordEntity.DEFAULT_CONTAINER.duplicate()

var channel_manager: BaseChannelManager
var emoji_manager: BaseEmojiManager
var guild_manager: BaseGuildManager
var message_manager: BaseMessageManager
var user_manager: BaseUserManager

var rest_mediator: DiscordRESTMediator

func get_or_construct_channel(data: Dictionary) -> Channel:
	var id: int = data["id"] as int
	var channel: Channel = self.get_channel(id)
	
	if channel:
		self.channel_manager.update_channel(channel, data)
	
	else:
		channel = self.channel_manager.construct_channel(data)	
		self.put_channel(channel)
	
	return channel

func get_or_construct_emoji(data: Dictionary) -> Emoji:
	return self.emoji_manager.construct_emoji(data)

func get_or_construct_guild(data: Dictionary) -> Guild:
	var id: int = data["id"] as int
	var guild: Guild = self.get_guild(id)
	
	if guild:
		self.guild_manager.update_guild(guild, data)
	
	else:
		guild = self.guild_manager.construct_guild(data)
		self.put_guild(guild)
	
	return guild

func get_or_construct_guild_member(data: Dictionary) -> Guild.Member:
	var id: int = data["user"]["id"] as int
	var guild: Guild = self.get_guild(data["guild_id"] as int)
	var member: Guild.Member
	if guild:
		member = guild.get_member(id)
	
	if member:
		self.guild_manager.update_guild_member(member, data)
	
	else:
		member = self.guild_manager.construct_guild_member(data)
	
	return member

func get_or_construct_message(data: Dictionary) -> Message:
	var id: int = data["id"] as int
	var message: Message = self.get_message(id)
	
	if message:
		self.message_manager.update_message(message, data)
	
	else:
		message = self.message_manager.construct_message(data)
		self.put_message(message)
	
	return message

func get_or_construct_user(data: Dictionary) -> User:
	var id: int = data["id"] as int
	var user: User = self.get_user(id)
	
	if user:
		self.user_manager.update_user(user, data)
	
	else:
		user = self.user_manager.construct_user(data)
		self.put_user(user)
	
	return user

func get_or_construct_presence(data: Dictionary) -> Presence:
	var id: int = data["user"]["id"] as int
	var presence: Presence = self.get_presence(id)
	
	if presence:
		self.user_manager.update_presence(presence, data)
	
	else:
		presence = self.user_manager.construct_presence(data)
		self.put_pesence(presence)
	
	return presence

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

class AbstractManager:
	
	var entity_manager: WeakRef
	
	func _init(manager: BaseDiscordEntityManager) -> void:
		self.entity_manager = weakref(manager)

	func get_manager() -> BaseDiscordEntityManager:
		return entity_manager.get_ref()
	
	func get_class() -> String:
		return "AbstractManager"
	
	func _to_string() -> String:
		return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

class BaseChannelManager extends AbstractManager:
	
	func _init(manager: BaseDiscordEntityManager).(manager) -> void:
		pass
	
	func construct_channel(_data: Dictionary) -> Channel:
		return null
	
	func update_channel(_channel: Channel, _data: Dictionary) -> void:
		pass
	
	func get_class() -> String:
		return "BaseChannelManager"

class BaseEmojiManager extends AbstractManager:
	
	func _init(manager: BaseDiscordEntityManager).(manager) -> void:
		pass
	
	func construct_emoji(_data: Dictionary) -> Emoji:
		return null

	func update_emoji(_emoji: Emoji, _data: Dictionary) -> void:
		pass

	func get_class() -> String:
		return "BaseEmojiManager"

class BaseGuildManager extends AbstractManager:
	
	func _init(manager: BaseDiscordEntityManager).(manager) -> void:
		pass
	
	func construct_guild(_data: Dictionary) -> Guild:
		return null
	
	func construct_guild_member(_data: Dictionary) -> Guild.Member:
		return null
	
	func construct_role(_data: Dictionary) -> Guild.Role:
		return null
	
	func update_guild(_guild: Guild, _data: Dictionary) -> void:
		pass

	func update_guild_member(_member: Guild.Member, _data: Dictionary) -> void:
		pass
	
	func update_role(_role: Guild.Role, _data: Dictionary) -> void:
		pass
	
	func get_class() -> String:
		return "BaseGuildManager"

class BaseMessageManager extends AbstractManager:
	
	func _init(manager: BaseDiscordEntityManager).(manager) -> void:
		pass
	
	func construct_message(_data: Dictionary) -> Message:
		return null
	
	func update_message(_message: Message, _data: Dictionary) -> void:
		pass
	
	func get_class() -> String:
		return "BaseMessageManager"

class BaseUserManager extends AbstractManager:
	
	func _init(manager: BaseDiscordEntityManager).(manager) -> void:
		pass
	
	func construct_user(_data: Dictionary) -> User:
		return null
	
	func construct_presence(_data: Dictionary) -> Presence:
		return null
	
	func update_user(_user: User, _data: Dictionary) -> void:
		pass
	
	func update_presence(_user: Presence, _data: Dictionary) -> void:
		pass
	
	func get_class() -> String:
		return "BaseUserManager"
