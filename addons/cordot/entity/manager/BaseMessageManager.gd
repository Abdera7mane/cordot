class_name BaseMessageManager

func construct_message(_data: Dictionary) -> Message:
	return null

func construct_embed_footer(_data: Dictionary) -> MessageEmbedFooter:
	return null

func construct_embed_image(_data: Dictionary) -> MessageEmbedImage:
	return null

func construct_embed_thumbnail(_data: Dictionary) -> MessageEmbedThumbnail:
	return null

func construct_embed_video(_data: Dictionary) -> MessageEmbedVideo:
	return null

func construct_embed_provider(_data: Dictionary) -> MessageEmbedProvider:
	return null
func construct_embed_author(_data: Dictionary) -> MessageEmbedAuthor:
	return null

func construct_embed_field(_data: Dictionary) -> MessageEmbedField:
	return null

func construct_message_attachment(_data: Dictionary) -> MessageAttachment:
	return null

func construct_message_reference(_data: Dictionary) -> MessageReference:
	return null

func construct_channel_mention(_data: Dictionary) -> ChannelMention:
	return null

func construct_reaction(_data: Dictionary) -> MessageReaction:
	return null

func update_message(_message: Message, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseMessageManager"
