# Contains information on the embed content provider such as YouTube and Twitch.
class_name MessageEmbedProvider

# Name of provider.
var name: String setget __set

# url of provider.
var url: String  setget __set

# doc-hide
func _init(_name: String, _url: String) -> void:
	name = _name
	url = _url

func __set(_value) -> void:
	pass
