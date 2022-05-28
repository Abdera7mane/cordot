class_name BaseUserManager

func construct_user(_data: Dictionary) -> User:
	return null

func construct_presence(_data: Dictionary) -> Presence:
	return null

func update_user(_user: User, _data: Dictionary) -> void:
	pass

func update_presence(_user: Presence, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseUserManager"
