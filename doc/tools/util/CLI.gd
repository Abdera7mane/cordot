
static func parse_cmdline_args() -> Dictionary:
	var cmdline_arg := {}
	var regex: RegEx = RegEx.new()
	# warning-ignore:return_value_discarded
	regex.compile('--(?<key>\\w+)((=|\\s)(?<value>[^-](".+"|\\S+)))?')
	for result in regex.search_all(OS.get_cmdline_args().join(" ")):
		cmdline_arg[result.get_string("key")] = str2var(result.get_string("value"))
	
	return cmdline_arg
