# Represents an application command event data.
class_name DiscordApplicationCommandData extends DiscordInteractionData

# Id of the executed command.
var command_id: int                                 setget __set

# Name of the executed command.
var name: String                                    setget __set

# Type of application command.
var type: int                                       setget __set
 
# Resolved entities data.  
var resolved: DiscordApplicationCommandResolvedData setget __set

# List of `DiscordApplicationCommandData.DataOption`s
# of user input.
var options: Array                                  setget __set

# Id of the user or message targeted by a user
# or message command.
var target_id: int                                  setget __set

# Id of the guild the command is registered to.
var guild_id: int                                   setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	command_id = data["command_id"]
	name = data["name"]
	type = data["type"]
	resolved = data.get("resolved")
	options = data.get("options", [])
	target_id = data.get("target_id", 0)
	guild_id = data.get("guild_id", 0)

# doc-hide
func get_class() -> String:
	return "DiscordApplicationCommandData"

func __set(_value) -> void:
	pass

# Represents the options sent along with
# an application command data.
class DataOption:
	# Option's name.
	var name: String   setget __set

	# Option's type.
	var type: int      setget __set
	
	# Option's value.
	var value          setget __set

	# If this option is group or a subcommand it contains a list of
	# `DiscordApplicationCommandData.DataOption`s.
	var options: Array setget __set
	
	# In an autocomplete interaction, this is `true` if user input is currently
	# focused on this option.
	var focused: bool  setget __set
	
	# doc-hide
	func _init(data: Dictionary) -> void:
		name = data["name"]
		type = data["type"]
		value = data.get("value")
		options = data.get("options", [])
		focused = data.get("focused", false)
	
	# doc-hide
	func get_class() -> String:
		return "DiscordApplicationCommandData.DataOption"
	
	func __set(_value) -> void:
		pass
