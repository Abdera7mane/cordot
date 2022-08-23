# Represents a ban entry in a guild.
class_name GuildBan

# The reason for the ban.
var reason: String setget __set

# The banned user.
var user: User     setget __set

# doc-hide
func _init(_reason: String, _user: User) -> void:
	reason = _reason
	user = _user

func __set(_value) -> void:
	pass
