class_name MessageReaction

var count: int    setget __set
var reacted: bool setget __set
var emoji: Emoji  setget __set

func _init(_count: int, _reacted: bool, _emoji: Emoji) -> void:
	count = _count
	reacted = _reacted
	emoji = _emoji

func equals(reaction: MessageReaction) -> bool:
	return reaction and emoji.equals(reaction.emoji)

func _update(data: Dictionary) -> void:
	count = data.get("count", count)
	reacted = data.get("reacted", reacted)
	emoji = data.get("emoji", emoji)

func __set(_value) -> void:
	pass
