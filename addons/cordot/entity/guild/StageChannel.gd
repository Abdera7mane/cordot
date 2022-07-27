class_name StageChannel extends BaseGuildVoiceChannel


var topic: String
var instance: StageInstance

func _init(data: Dictionary) -> void:
	super(data)
	type = Channel.Type.GUILD_STAGE_VOICE

func get_class() -> String:
	return "Guild.StageChannel"

func _update(data: Dictionary) -> void:
	topic = data.get("topic", topic)
	instance = data.get("instance", instance)

func _clone_data() -> Array:
	var data: Array = super()

	var arguments: Dictionary = data[0]
	arguments["topic"] = self.topic
	arguments["instance"] = self.instance

	return data

#	func __set(_value) -> void:
#		pass
