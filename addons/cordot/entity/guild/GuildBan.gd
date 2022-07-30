class_name GuildBan

var reason: String
var user: User

func _init(_reason: String, _user: User) -> void:
	reason = _reason
	user = _user
