class_name VoiceChannel extends Channel

enum VideoQualityModes {
	AUTO,
	FULL
}

var bitrate: int setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	bitrate = data["bitrate"]

func get_class() -> String:
	return "VoiceChannel"

func __set(_value) -> void:
	.__set(_value)
