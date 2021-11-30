class_name PartialChannel extends DiscordEntity

var name: String setget __set

func _init(id: int, _name: String).(id) -> void:
	name = _name

func is_partial() -> bool:
	return true

func __set(_value) -> void:
	pass
