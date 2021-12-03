class_name Channel extends MentionableEntity

enum Type {
	UNKNOWN = -1,
	GUILD_TEXT,
	DM,
	GUILD_VOICE,
	GROUP_DM,
	GUILD_CATEGORY,
	GUILD_NEWS,
	GUILD_STORE,
	GUILD_NEWS_THREAD    = 10,
	GUILD_PUBLIC_THREAD  = 11,
	GUILD_PRIVATE_THREAD = 12,
	GUILD_STAGE_VOICE    = 13
}

var type: int setget __set

func _init(id: int).(id) -> void:
	pass

func get_mention() -> String:
	return "<#%d>" % self.id

func get_creation_timestamp() -> int:
	return self.snowflake.get_timestamp()

func is_guild() -> bool:
	return "guild_id" in self

func is_text() -> bool:
	return "last_message_id" in self

func is_voice() -> bool:
	return "bitrate" in self

func get_class() -> String:
	return "Channel"

func _update(_data: Dictionary) -> void:
	pass

func __set(_value) -> void:
	pass
