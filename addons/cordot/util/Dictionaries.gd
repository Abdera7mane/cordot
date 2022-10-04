class_name Dictionaries

static func has_non_null(dict, key) -> bool:
	return dict.get(key) != null

static func get_non_null(dict: Dictionary, key, default):
	var value = dict.get(key)
	return value if value != null else default

static func merge(a: Dictionary, b: Dictionary, overwrite = false) -> void:
	for key in b:
		if a.has(key) and not overwrite:
			continue
		a[key] = b[key]
