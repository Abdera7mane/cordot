class_name DiscordEntityManager extends BaseDiscordEntityManager

func _init() -> void:
	self.application_manager = DiscordApplicationManager.new(self)
	self.channel_manager = ChannelManager.new(self)
	self.emoji_manager = EmojiManager.new(self)
	self.guild_manager = GuildManager.new(self)
	self.interaction_manager = DiscordInteractionManager.new(self)
	self.message_manager = MessageManager.new(self)
	self.user_manager = UserManager.new(self)

func get_class() -> String:
	return "DiscordEntityManager"
