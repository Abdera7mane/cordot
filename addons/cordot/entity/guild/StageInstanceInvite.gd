# doc-deprecated
class_name StageInstanceInvite

var members: Array         setget __set
var participant_count: int setget __set
var speaker_count: int     setget __set
var topic: String          setget __set

# doc-hide
func _init(data: Dictionary) -> void:
	members = data["members"]
	participant_count = data["participant_count"]
	speaker_count = data["speaker_count"]
	topic = data["topic"]

# doc-hide
func get_class() -> String:
	return "StageInstanceInvite"

func __set(_value) -> void:
	pass
