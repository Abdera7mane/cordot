class_name GuildNewsChannel extends GuildTextChannel

func _init(data: Dictionary) -> void:
	super(data)
	type = Channel.Type.GUILD_NEWS

func get_class() -> String:
	return "Guild.GuildNewsChannel"
