class_name EmojiManager extends BaseDiscordEntityManager.BaseEmojiManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_emoji(data: Dictionary) -> Emoji:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var user: User
	if data.has("user"):
		user = manager.get_or_construct_user(data["user"])
	var arguments: Dictionary = {
		id = data["id"] as int,
		guild_id = data["guild_id"],
		name = Dictionaries.get_non_null(data, "name" , ""),
		roles_ids = Snowflake.snowflakes2integers(data.get("roles", [])),
		user_id = user.id if user else 0,
		is_managed = data.get("managed"),
		is_animated = data.get("animated"),
		available = data.get("available"),
	}
	
	var emoji: Emoji = Guild.GuildEmoji.new(arguments)
	emoji.set_meta("container", manager.container)
	emoji.set_meta("rest", manager.rest_mediator)
	
	return emoji

func get_class() -> String:
	return "EmojiManager"
