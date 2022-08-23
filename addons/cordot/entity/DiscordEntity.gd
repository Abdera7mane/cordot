# Abstract class for Discord API objects.
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

# `Snowflake` representation of this object's `id.
var snowflake: Snowflake setget __set

# Object's id.
var id: int              setget __set, get_id

func _init(_id: int) -> void:
	snowflake = Snowflake.new(_id)

# Clone this object instance, not implemented in all sub classes.
func clone() -> DiscordEntity:
	var clone: DiscordEntity = self.get_script().callv("new", self._clone_data())
	clone.set_meta("container", get_container())
	if has_meta("partial"):
		clone.set_meta("partial", get_meta("partial"))
	if has_meta("rest"):
		clone.set_meta("rest", get_meta("rest"))
	return clone

# Check whether this instance is equal to `entity`.
# returns `true` If the `entity.id` and the object type matches.
func equals(entity: DiscordEntity) -> bool:
	return entity and self.id == entity.id and get_script() == entity.get_script()

# Returns true if this object is partial. A partial object has uncompleted data
# so its properties are unreliable to work with.
func is_partial() -> bool:
	return self.get_meta("partial") if self.has_meta("partial") else false

# `id` getter.
func get_id() -> int:
	return self.snowflake.id

# doc-hide
func get_container() -> Dictionary:
	return self.get_meta("container") if self.has_meta("container") else DEFAULT_CONTAINER

# doc-hide
func get_rest() -> DiscordRESTMediator:
	return self.get_meta("rest")

# doc-hide
func get_class() -> String:
	return "DiscordEntity"

func _clone_data() -> Array:
	return []

func _to_string() -> String:
	return "[%s<%d>:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	pass
