class_name DiscordVoiceRegion

var id: String       
var name: String     
var vip: bool        
var optimal: bool    
var deprecated: bool 
var custom: bool     

func _init(_id: String, _name: String, _vip: bool, _optimal: bool, _deprecated: bool, _custom: bool) -> void:
	id = _id
	name = _name
	vip = _vip
	optimal = _optimal
	deprecated = _deprecated
	custom = _custom

func __set(_value) -> void:
	pass
