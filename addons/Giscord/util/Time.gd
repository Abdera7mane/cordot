class_name TimeUtil

static func iso_to_unix(iso_timestamp: String) -> int:
	if iso_timestamp.empty():
		return 0
	
	var regex: RegEx = RegEx.new()
	# warning-ignore:return_value_discarded
	regex.compile("(?<year>\\d{4})-(?<month>\\d{2})-(?<day>\\d{2})T(?<hours>\\d{2}):(?<minutes>\\d{2}):(?<seconds>\\d{2})((?<microseconds>.\\d{6}))?\\+\\d{2}:\\d{2}")
	var regex_match: RegExMatch = regex.search(iso_timestamp)

	return OS.get_unix_time_from_datetime({
		year = regex_match.get_string("year") as int,
		mounth = regex_match.get_string("month") as int,
		day = regex_match.get_string("day") as int,
		hour = regex_match.get_string("hours") as int,
		minute = regex_match.get_string("minutes") as int,
		second = regex_match.get_string("seconds") as int 
	})
