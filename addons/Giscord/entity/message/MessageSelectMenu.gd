class_name MessageSelectMenu extends MessageComponent

var custom_id: String   setget __set
var disabled: bool      setget __set
var options: Array      setget __set
var placeholder: String setget __set
var min_values: int     setget __set
var max_values: int     setget __set

func get_class() -> String:
	return "MessageSticker"

func __set(_value) -> void:
	.__set(_value)
