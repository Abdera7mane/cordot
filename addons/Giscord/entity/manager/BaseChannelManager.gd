class_name BaseChannelManager

func construct_channel(_data: Dictionary) -> Channel:
	return null

func construct_partial_channel(_data: Dictionary) -> PartialChannel:
	return null

func update_channel(_channel: Channel, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseChannelManager"
