class_name DiscordInteractionData

func get_class() -> String:
	return "DiscordInteractionData"

func _to_string() -> String:
	return "[%s:%d]" % [get_class(), get_instance_id()]
