class_name MessageButton extends MessageComponent

var custom_id: String 
var disabled: bool    
var style: int        
var label: String     
var emoji: Emoji      
var url: String       

func get_class() -> String:
	return "MessageButton"

func __set(_value) -> void:
	pass
