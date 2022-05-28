class_name DiscordApplicationCommandOption

enum Option {
	SUB_COMMAND       = 1,
	SUB_COMMAND_GROUP = 2,
	STRING            = 3,
	INTEGER           = 4,
	BOOLEAN           = 5,
	USER              = 6,
	CHANNEL           = 7,
	ROLE              = 8,
	MENTIONABLE       = 9,
	NUMBER            = 10,
	ATTACHMENT        = 11
}

var type: int                   setget __set
var name: String                setget __set
var description: String         setget __set
var required: bool              setget __set
var choices: Array              setget __set
var options: Array              setget __set
var channel_types: PoolIntArray setget __set
var min_value: float            setget __set
var max_value: float            setget __set
var autocomplete: bool          setget __set

func _init(data: Dictionary) -> void:
	type = data["type"]
	name = data["name"]
	description = data["description"]
	required = data.get("required", false)
	choices = data.get("choices", [])
	options = data.get("options", [])
	channel_types = data.get("channel_types", [])
	min_value = data.get("min_value", NAN)
	max_value = data.get("max_value", NAN)
	autocomplete = data.get("autocomplete", false)

func get_class() -> String:
	return "DiscordApplicationCommandOption"

func __set(_value) -> void:
	pass
