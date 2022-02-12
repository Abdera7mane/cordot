class_name DiscordEntity

const DEFAULT_CONTAINER: Dictionary = {
	applications = {},
	channels     = {},
	guilds       = {},
	messages     = {},
	presences    = {},
	users        = {},
	teams        = {},
	bot_id       = 0
}

var snowflake: Snowflake setget __set
var id: int              setget __set, get_id

func _init(_id: int) -> void:
	snowflake = Snowflake.new(_id)

func clone() -> DiscordEntity:
	var clone: DiscordEntity = self.get_script().callv("new", self._clone_data())
	clone.set_meta("container", get_container())
	if clone.has_meta("partial"):
		clone.set_meta("partial", get_meta("partial"))
	if clone.has_meta("rest"):
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

func get_properties() -> Dictionary:
	var properties: Dictionary = {}
	for property in self.get_property_list():
		var name: String = property["name"]
		properties[name] = self.get(name)
	return properties

func get_class() -> String:
	return "DiscordEntity"

func _clone_data() -> Array:
	return []

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			pass

func _to_string() -> String:
	return "[%s<%d>:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	pass
