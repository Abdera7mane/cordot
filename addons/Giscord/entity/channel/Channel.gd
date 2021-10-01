class_name Channel extends MentionableEntity

enum Type {
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

# warning-ignore:unused_argument
func compare_to(channel: Channel) -> int:
	return OP_NOT_EQUAL

func get_mention() -> String:
	return "<#%d>" % self.id

func get_creation_date() -> int:
	return self.snowflake.get_timestamp()

func get_class() -> String:
	return "Channel"

func __set(_value) -> void:
	.__set(_value)
