class_name DiscordEntity

const DEFAULT_CONTAINER: Dictionary = {
	applications = {},
	channels     = {},
	guilds       = {},
	messages     = {},
	presences    = {},
	users        = {},
	teams        = {}
}

var snowflake: Snowflake setget __set
var id: int              setget __set, get_id

func _init(_id: int) -> void:
	snowflake = Snowflake.new(_id)

func get_id() -> int:
	return self.snowflake.id

func get_container() -> Dictionary:
	return self.get_meta("container") if self.has_meta("container") else DEFAULT_CONTAINER

func is_partial() -> bool:
	return self.get_meta("partial") if self.has_meta("partial") else false

func get_class() -> String:
	return "DiscordEntity"

func _to_string() -> String:
	return "[%s<%d>:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	GDUtil.protected_setter_printerr(self, get_stack())
