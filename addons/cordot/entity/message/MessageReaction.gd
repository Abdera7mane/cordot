# Represents an emoji reaction to a message.
class_name MessageReaction

# Number of reactions of `emoji`.
var count: int    setget __set

# Whether the current user reacted using `emoji`.
var reacted: bool setget __set

# The emoji used in this reaction.
var emoji: Emoji  setget __set

# doc-hide
func _init(_count: int, _reacted: bool, _emoji: Emoji) -> void:
	count = _count
	reacted = _reacted
	emoji = _emoji

# doc-hide
func equals(reaction: MessageReaction) -> bool:
	return reaction and emoji.equals(reaction.emoji)

func _update(data: Dictionary) -> void:
	count = data.get("count", count)
	reacted = data.get("reacted", reacted)
	emoji = data.get("emoji", emoji)

func __set(_value) -> void:
	pass
