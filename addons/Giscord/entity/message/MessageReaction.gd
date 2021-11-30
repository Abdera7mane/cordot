class_name MessageReaction

var count: int    setget __set
var reacted: bool setget __set
var emoji: Emoji  setget __set

func _init(_count: int, _reacted: bool, _emoji: Emoji) -> void:
	count = _count
	reacted = _reacted
	_emoji = _emoji

func __set(_value) -> void:
	pass
