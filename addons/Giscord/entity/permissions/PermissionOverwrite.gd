class_name PermissionOverwrite

enum Type {
	ROLE,
	MEMBER
}

var id: int    setget __set
var type: int  setget __set
var allow: int setget __set
var deny: int  setget __set

func _init(data: Dictionary):
	id = data.id
	type = data.type
	allow = data.allow
	deny = data.deny

func __set(_value) -> void:
	pass
