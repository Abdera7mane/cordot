class_name MessageButton extends MessageComponent

var custom_id: String setget __set
var disabled: bool    setget __set
var style: int        setget __set
var label: String     setget __set
var emoji: Emoji      setget __set
var url: String       setget __set

func get_class() -> String:
	return "MessageButton"

func __set(_value) -> void:
	.__set(_value)
