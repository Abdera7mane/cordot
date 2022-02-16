class_name DiscordVoiceRegion

var id: String       setget __set
var name: String     setget __set
var vip: bool        setget __set
var optimal: bool    setget __set
var deprecated: bool setget __set
var custom: bool     setget __set

func _init(_id: String, _name: String, _vip: bool, _optimal: bool, _deprecated: bool, _custom: bool) -> void:
	id = _id
	name = _name
	vip = _vip
	optimal = _optimal
	deprecated = _deprecated
	custom = _custom

func __set(_value) -> void:
	pass
