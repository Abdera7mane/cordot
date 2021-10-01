class_name MessageComponent

enum Types {
	ACTION_ROW,
	BUTTON,
	SELECT_MENU
}

var type: int setget __set

func get_class() -> String:
	return "MessageComponent"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	GDUtil.protected_setter_printerr(self, get_stack())
