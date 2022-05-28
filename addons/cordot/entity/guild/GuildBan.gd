class_name GuildBan

var reason: String setget __set
var user: User     setget __set

func _init(_reason: String, _user: User) -> void:
	reason = _reason
	user = _user

func __set(_value) -> void:
	pass
