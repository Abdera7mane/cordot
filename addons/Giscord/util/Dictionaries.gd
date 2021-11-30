class_name Dictionaries

static func has_non_null(dict, key) -> bool:
	return dict.get(key) != null

static func get_non_null(dict: Dictionary, key, default):
	var value = dict.get(key)
	return value if value != null else default

static func merge(a: Dictionary, b: Dictionary) -> Dictionary:
	var dict: Dictionary = a.duplicate()
	for key in b:
		dict[key] = b[key]
	return dict
