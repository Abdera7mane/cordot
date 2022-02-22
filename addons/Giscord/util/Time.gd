class_name TimeUtil

static func iso_to_unix(iso_timestamp: String) -> int:
	if iso_timestamp.empty():
		return 0
	
	var date: Array = iso_timestamp.split("T", false)
	if date.size() != 2:
		return 0
	
	date[0] = date[0].split("-")
	date[1] = date[1].trim_suffix("Z").split(":")
	
	return OS.get_unix_time_from_datetime({
		year = int(date[0][0]),
		month = int(date[0][1]),
		day = int(date[0][2]),
		hour = int(date[1][0]),
		minute = int(date[1][1]),
		second = float(date[1][2])
	})

static func unix_to_iso(unix_timestamp: int) -> String:
	var date: Dictionary = OS.get_datetime_from_unix_time(unix_timestamp)
	return "%d-%02d-%02dT%02d:%02d:%02d" % [
		date["year"],
		date["month"],
		date["day"],
		date["hour"],
		date["minute"],
		date["second"]
	]
