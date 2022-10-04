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

func construct_message_component(data: Dictionary) -> MessageComponent:
	var component: MessageComponent = null
	var type: int = data["type"]
	match type:
		MessageComponent.Type.ACTION_ROW:
			component = construct_action_row(data)
		MessageComponent.Type.BUTTON:
			component = construct_button(data)
		MessageComponent.Type.SELECT_MENU:
			component = construct_select_menu(data)
		MessageComponent.Type.TEXT_IPUT:
			component = construct_text_input(data)
	return component

func construct_action_row(_data: Dictionary) -> MessageActionRow:
	return null

func construct_button(_data: Dictionary) -> MessageButton:
	return null

func construct_select_menu(_data: Dictionary) -> MessageSelectMenu:
	return null

func construct_select_option(_data: Dictionary) -> MessageSelectOption:
	return null

func construct_text_input(_data: Dictionary) -> MessageTextInput:
	return null

func update_message(_message: Message, _data: Dictionary) -> void:
	pass

func get_class() -> String:
	return "BaseMessageManager"
