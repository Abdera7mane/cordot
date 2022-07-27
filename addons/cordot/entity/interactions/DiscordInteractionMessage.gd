class_name DiscordInteractionMessage extends DiscordInteractionCallback

var tts: bool                
var content: String          
var embeds: Array            
var allowed_mentuons: Object 
var flags: BitFlag           
var components: Array        
var attachments: Array       

func _init() -> void:
	flags = BitFlag.new(Message.Flags)

func set_tts(value: bool) -> DiscordInteractionMessage:
	tts = value
	return self

func set_content(_content: String) -> DiscordInteractionMessage:
	content = _content.strip_edges()
	return self

func add_embed(embed: MessageEmbedBuilder) -> DiscordInteractionMessage:
	if embeds.size() < 10:
		embeds.append(embed.build())
	else:
		push_error("Message embeds are limited to 10")
	return self

func suppress_emebds(value: bool) -> DiscordInteractionMessage:
	flags.SUPPRESS_EMBEDS = value
	return self

func ephemeral(value: bool) -> DiscordInteractionMessage:
	flags.EPHEMERAL = value
	return self

func to_dict() -> Dictionary:
	var data: Dictionary = {tts = tts}
	if not content.is_empty():
		data["content"] = content
	if embeds.size() > 0:
		data["embeds"] = embeds
	if allowed_mentuons:
		pass
	if flags.flags:
		data["flags"] = flags.flags
	if components.size() > 0:
		data["components"] = components
	if attachments.size() > 0:
		data["attachments"] = attachments
	
	return data

func get_class() -> String:
	return "DiscordInteractionMessage"

func __set(_value) -> void:
	pass
