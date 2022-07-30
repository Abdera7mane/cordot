class_name StageInstanceInvite

var members: Array         
var participant_count: int 
var speaker_count: int     
var topic: String          

func _init(data: Dictionary) -> void:
	members = data["members"]
	participant_count = data["participant_count"]
	speaker_count = data["speaker_count"]
	topic = data["topic"]

func get_class() -> String:
	return "StageInstanceInvite"
