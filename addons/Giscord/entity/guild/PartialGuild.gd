class_name PartialGuild extends DiscordEntity

var name: String      setget __set
var icon_hash: String setget __set

func _init(id: int, _name: String, _icon_hash: String).(id) -> void:
	name = _name
	icon_hash = _icon_hash

func is_partial() -> bool:
	return true

func __set(_value) -> void:
	pass
