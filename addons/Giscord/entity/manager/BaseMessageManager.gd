class_name BaseMessageManager

func construct_message(_data: Dictionary) -> Message:
	return null

func construct_reaction(_data: Dictionary) -> MessageReaction:
	return null

func update_message(_message: Message, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseMessageManager"
