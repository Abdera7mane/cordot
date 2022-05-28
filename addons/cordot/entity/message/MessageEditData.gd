class_name MessageEditData

var _data: Dictionary setget __set, to_dict

func set_content(name: String) -> MessageEditData:
	_data["content"] = name.strip_edges()
	return self

func add_embed(embed: MessageEmbedBuilder) -> MessageEditData:
	if not _data.has("embeds"):
		_data["embeds"] = []
	
	var embeds: Array = _data["embeds"]
	if embeds.size() < 10:
		embeds.append(embed.build())
	else:
		push_error("Message emebds are limited to 10")
		
	return self

func set_allowed_mentions(allowed: Dictionary) -> MessageEditData:
	_data["allowed_mentions"] = allowed
	return self

func add_component(component: Dictionary) -> MessageEditData:
	if not _data.has("components"):
		_data["components"] = []
	_data["components"].append(component)
	return self

func add_attachment(attachment: Dictionary) -> MessageEditData:
	if not _data.has("attachments"):
		_data["attachments"] = []
	_data["attachments"].append(attachment)
	return self

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "MessageEditData"

func __set(_value) -> void:
	pass
