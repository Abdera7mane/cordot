class_name EmojiManager extends BaseEmojiManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	self.entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_emoji(data: Dictionary) -> Emoji:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var emoji: Emoji
	
	if Dictionaries.has_non_null(data, "id"):
		var user: User
		if data.has("user"):
			user = manager.get_or_construct_user(data["user"])
		emoji = Guild.GuildEmoji.new({
			id = data["id"] as int,
			guild_id = data["guild_id"],
			name = Dictionaries.get_non_null(data, "name" , ""),
			roles_ids = Snowflake.snowflakes2integers(data.get("roles", [])),
			user_id = user.id if user else 0,
			is_managed = data.get("managed", false),
			is_animated = data.get("animated", false),
			available = data.get("available", false),
	})
	else:
		emoji = UnicodeEmoji.new(data["name"])
		

	emoji.set_meta("container", manager.container)
	emoji.set_meta("rest", manager.rest_mediator)
	
	return emoji

func get_class() -> String:
	return "EmojiManager"
