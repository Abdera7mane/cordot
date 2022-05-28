# Reference:
# https://github.com/godot-extended-libraries/godot-next/blob/master/addons/godot-next/references/bit_flag.gd

class_name BitFlag

var _current_index: int setget __set

var enum_set: Dictionary setget __set, get_enum
var flags: int

func _init(_enum: Dictionary) -> void:
	enum_set = _enum

func put(flag: int) -> BitFlag:
	flags |= flag
	return self

func clear(flag: int) -> BitFlag:
	flags &= ~flag
	return self

func has(flag: int) -> bool:
	return (flags & flag) == flag

func toggle(flag: int) -> BitFlag:
	flags ^= flag
	return self

func reset() -> BitFlag:
	flags = 0
	return self

func all() -> bool:
	for value in self:
		if not value:
			return false
	return true

func none() -> bool:
	for value in self:
		if value:
			return false
	return true

func get_enum() -> Dictionary:
	return enum_set.duplicate()

func get_keys() -> PoolStringArray:
	return PoolStringArray(enum_set.keys())

func get_values() -> PoolIntArray:
	return PoolIntArray(enum_set.values())

func get_class() -> String:
	return "Bitflag"

func clone() -> BitFlag:
	var clone: BitFlag = get_script().new(enum_set)
	clone.flags = flags
	return clone

func enable_all() -> BitFlag:
	flags = int(pow(2, size())) - 1
	return self

func disable_all() -> BitFlag:
	flags = 0
	return self

func size() -> int:
	return enum_set.size()

func _set(property: String, value) -> bool:
	if enum_set.has(property):
		if bool(value):
			# warning-ignore:return_value_discarded
			put(enum_set[property])
		else:
			# warning-ignore:return_value_discarded
			clear(enum_set[property])
		return true
	return false

func _get(property: String):
	if enum_set.has(property):
		return has(enum_set[property])
	return null

func _get_property_list() -> Array:
	var properties: Array = []
	for key in enum_set:
		properties.append({
			name = key,
			type = TYPE_BOOL,
			usage = PROPERTY_USAGE_DEFAULT
		})
	return properties

func _iter_resume() -> bool:
	return enum_set.size() >= _current_index + 1

func _iter_init(_arg) -> bool:
	_current_index = 0
	return _iter_resume()

func _iter_next(_arg) -> bool:
	_current_index += 1
	return _iter_resume()

func _iter_get(_arg) -> String:
	return enum_set.keys()[_current_index]

func _to_string() -> String:
	return str(enum_set) + ", flags: %d" % flags

func __set(_value) -> void:
	pass
