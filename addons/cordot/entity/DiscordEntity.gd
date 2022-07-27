class_name DiscordEntity

const DEFAULT_CONTAINER: Dictionary = {
	applications = {},
	channels     = {},
	guilds       = {},
	messages     = {},
	presences    = {},
	users        = {},
	teams        = {},
	bot_id       = 0,
	application_id = 0
}

var snowflake: Snowflake
var id: int:
	get = get_id

func _init(_id: int) -> void:
	snowflake = Snowflake.new(_id)

func clone() -> DiscordEntity:
	var clone: DiscordEntity = self.get_script().callv("new", self._clone_data())
	clone.set_meta("container", get_container())
	if has_meta("partial"):
		clone.set_meta("partial", get_meta("partial"))
	if has_meta("rest"):
		clone.set_meta("rest", get_meta("rest"))
	return clone

func equals(entity: DiscordEntity) -> bool:
	return entity and self.id == entity.id and get_script() == entity.get_script()

func is_partial() -> bool:
	return self.get_meta("partial") if self.has_meta("partial") else false

func get_id() -> int:
	return self.snowflake.id

func get_container() -> Dictionary:
	return self.get_meta("container") if self.has_meta("container") else DEFAULT_CONTAINER

func get_rest() -> DiscordRESTMediator:
	return self.get_meta("rest")

func get_class() -> String:
	return "DiscordEntity"

func _clone_data() -> Array:
	return []

func _to_string() -> String:
	return "[%s<%d>:%d]" % [self.get_class(), self.id, self.get_instance_id()]

#func __set(_value) -> void:
#	pass
