class_name GDUtil

static func dict_get_or_default(dict: Dictionary, key, default):
	var value = dict.get(key)
	return value if value else default

static func iso_to_unix_timestamp(iso_timestamp: String) -> int:
	if iso_timestamp.empty():
		return 0
	"2021-04-08T12:59:27.876000+00:00"
	var regex: RegEx = RegEx.new()
	# warning-ignore:return_value_discarded
	regex.compile("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})T(?<hours>\\d{2}):(?<minutes>\\d{2}):(?<seconds>\\d{2})((?<microseconds>.\\d{6}))?\\+\\d{2}:\\d{2}")
	var regex_match: RegExMatch = regex.search(iso_timestamp)

	return OS.get_unix_time_from_datetime({
		"year": regex_match.get_string(regex_match.names["year"]) as int,
		"month": regex_match.get_string(regex_match.names["month"]) as int,
		"day": regex_match.get_string(regex_match.names["day"]) as int,
		"hour": regex_match.get_string(regex_match.names["hours"]) as int,
		"minute": regex_match.get_string(regex_match.names["minutes"]) as int,
		"second": regex_match.get_string(regex_match.names["seconds"]) as int 
	})

static func protected_setter_printerr(object: Object, stack: Array) -> void:
	var _details: Dictionary = stack[-2]
	assert(false, "Script tried to set a get-only property of \"%s\" instance" % [object.get_class()])
