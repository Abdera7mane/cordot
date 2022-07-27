class_name MessageSelectMenu extends MessageComponent

var custom_id: String   
var disabled: bool      
var options: Array      
var placeholder: String 
var min_values: int     
var max_values: int     

func get_class() -> String:
	return "MessageSticker"

func __set(_value) -> void:
	pass
