class_name GuildVoiceChannel extends BaseGuildVoiceChannel


var user_limit: int
var video_quality: int

func _init(data: Dictionary) -> void:
	super(data)
	type = Channel.Type.GUILD_VOICE

func get_class() -> String:
	return "GuildVoiceChannel"

func _update(data: Dictionary) -> void:
	user_limit = data.get("user_limit", user_limit)
	video_quality = data.get("var video_quality", video_quality)

func _clone_data() -> Array:
	var data: Array = super()

	var arguments: Dictionary = data[0]
	arguments["user_limit"] = self.user_limit
	arguments["video_quality"] = self.video_quality

	return data

#	func __set(_value) -> void:
#		pass
