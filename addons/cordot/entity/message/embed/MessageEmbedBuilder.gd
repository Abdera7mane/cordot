class_name MessageEmbedBuilder

var _data: Dictionary 

func set_title(title: String) -> MessageEmbedBuilder:
	_data["title"] = title
	return self

func set_description(description: String) -> MessageEmbedBuilder:
	_data["description"] = description
	return self

func set_url(url: String) -> MessageEmbedBuilder:
	_data["url"] = url
	return self

func set_timestamp(unix_timestamp: int) -> MessageEmbedBuilder:
	_data["timestamp"] = TimeUtil.unix_to_iso(unix_timestamp)
	return self

func set_color(color: Color) -> MessageEmbedBuilder:
	color.a = 0
	_data["color"] = color.to_argb32()
	return self

func set_footer(footer: MessageEmbedFooterBuilder) -> MessageEmbedBuilder:
	_data["footer"] = footer.build()
	return self

func set_image(image: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["image"] = image.build()
	return self

func set_thumbnail(thumbnail: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["thumbnail"] = thumbnail.build()
	return self

func set_video(video: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["video"] = video.build()
	return self

func set_provider(provider: MessageEmbedProviderBuilder) -> MessageEmbedBuilder:
	_data["provider"] = provider.build()
	return self

func set_author(author: MessageEmbedAuthorBuilder) -> MessageEmbedBuilder:
	_data["author"] = author.build()
	return self

func add_field(name: String, value: String, inline: bool = false) -> MessageEmbedBuilder:
	if not _data.has("fields"):
		_data["fields"] = []
	var fields: Array = _data["fields"]
	if fields.size() < 25:
		fields.append({
			name = name,
			value = value,
			inline = inline
		})
	else:
		push_error("Emebd fields are limited to 25")
	return self

func build() -> Dictionary:
	var data: Dictionary = _data.duplicate()
	return data

func get_class() -> String:
	return "MessageEmbedBuilder"

func __set(_value) -> void:
	pass
