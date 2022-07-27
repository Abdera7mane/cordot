class_name VoiceChannel extends Channel

enum VideoQualityModes {
	AUTO,
	FULL
}

var bitrate: int

func _init(data: Dictionary) -> void:
	super(data["id"])
	_update(data)

func get_class() -> String:
	return "VoiceChannel"

func _update(data: Dictionary) -> void:
	bitrate = data.get("bitrate", bitrate)

func _clone_data() -> Array:
	return [{
		id = self.id,
		bitrate = self.bitrate
	}]

#func __set(_value) -> void:
#	pass
