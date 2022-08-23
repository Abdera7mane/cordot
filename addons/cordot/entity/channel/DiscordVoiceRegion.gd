# Represents a Discord voice region.
class_name DiscordVoiceRegion

# Unique ID for the region.
var id: String       setget __set

# Name of the region.
var name: String     setget __set

var vip: bool        setget __set

# `true` for a single server that is closest to the current user's client.
var optimal: bool    setget __set

# Whether this is a deprecated voice region.
var deprecated: bool setget __set

# Whether the region is custom.
var custom: bool     setget __set

# doc-hide
func _init(_id: String, _name: String, _vip: bool, _optimal: bool, _deprecated: bool, _custom: bool) -> void:
	id = _id
	name = _name
	vip = _vip
	optimal = _optimal
	deprecated = _deprecated
	custom = _custom

func __set(_value) -> void:
	pass
