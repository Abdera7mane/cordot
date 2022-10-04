# Helper class to build message embeds.
class_name MessageEmbedBuilder

const MAX_FIELDS: int = 25

var _data: Dictionary setget __set

# Sets the embed's title.
func set_title(title: String) -> MessageEmbedBuilder:
	_data["title"] = title
	return self

# Sets the embed's description.
func set_description(description: String) -> MessageEmbedBuilder:
	_data["description"] = description
	return self

# Sets the embed's url.
func set_url(url: String) -> MessageEmbedBuilder:
	_data["url"] = url
	return self

# Sets the embed's timestamp. `unix_timestamp` takes a Unix time in seconds.
func set_timestamp(unix_timestamp: int) -> MessageEmbedBuilder:
	_data["timestamp"] = TimeUtil.unix_to_iso(unix_timestamp)
	return self

# Sets the embed's color.
func set_color(color: Color) -> MessageEmbedBuilder:
	color.a = 0
	_data["color"] = color.to_argb32()
	return self

# Sets the embed's footer information.
func set_footer(footer: MessageEmbedFooterBuilder) -> MessageEmbedBuilder:
	_data["footer"] = footer
	return self

# Sets the embed's image.
func set_image(image: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["image"] = image
	return self

# Sets the embed's thumbnail.
func set_thumbnail(thumbnail: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["thumbnail"] = thumbnail
	return self

# Sets the embed's video.
func set_video(video: MessageEmbedAttachmentBuilder) -> MessageEmbedBuilder:
	_data["video"] = video
	return self

# Sets the embed's provider information.
func set_provider(provider: MessageEmbedProviderBuilder) -> MessageEmbedBuilder:
	_data["provider"] = provider
	return self

# Sets the embed's author information.
func set_author(author: MessageEmbedAuthorBuilder) -> MessageEmbedBuilder:
	_data["author"] = author
	return self

# Adds a field to the embed. if `inline` is `true`, the field will displayed on 
# the same line next to the previous field. You can add up to 25 fields.
func add_field(name: String, value: String, inline: bool = false) -> MessageEmbedBuilder:
	if not _data.has("fields"):
		_data["fields"] = []
	var fields: Array = _data["fields"]
	if fields.size() < MAX_FIELDS:
		fields.append({
			name = name,
			value = value,
			inline = inline
		})
	else:
		push_error("Emebd fields are limited to %d" % MAX_FIELDS)
	return self

# Returns the embed data as a `Dictionary`.
func build() -> Dictionary:
	var data: Dictionary = _data.duplicate()
	if data.has("footer"):
		data["footer"] = data["footer"].build()
	if data.has("image"):
		data["image"] = data["image"].build()
	if data.has("thumbnail"):
		data["thumbnail"] = data["thumbnail"].build()
	if data.has("video"):
		data["video"] = data["video"].build()
	if data.has("provider"):
		data["provider"] = data["provider"].build()
	if data.has("author"):
		data["author"] = data["author"].build()
	return data

# doc-hide
func get_class() -> String:
	return "MessageEmbedBuilder"

func __set(_value) -> void:
	pass
