# Finds and generates a code reference from gdscript files.
tool

const QUALIFIERS := PoolStringArray([
	"coroutine",
	"virtual"
])

var annotations_regex := RegEx.new()

func _init() -> void:
	var annotations: PoolStringArray = [
		"warnings-disable",
		"doc-hide",
		"doc-show",
		"doc-deprecated"
	]
	var annotations_with_value: PoolStringArray = [
		"warning-ignore(-all)?",
		"doc-override-return",
		"doc-override-param-default",
		"doc-qualifiers"
	]
	var pattern := (
		  "(?m)(^|\\n)"
		+ "(?<annotation>(%s)|(%s):(\\w+|\\(.+\\)))\\s*"
		+ "($|\\n)"
	) % [
			annotations.join("|"),
			annotations_with_value.join("|")
	]
	
	var error := annotations_regex.compile(pattern)
	if error != OK:
		printerr("Failed to compile '%s' to a regex pattern." % pattern)


# Returns a list of file paths found in the directory.
#
# **Arguments**
#
# - dirpath: path to the directory from which to search files.
# - patterns: an array of string match patterns, where "*" matches zero or more
#   arbitrary characters and "?" matches any single character except a period
#   ("."). You can use it to find files by extensions. To find only GDScript
#   files, ["*.gd"]
# - is_recursive: if `true`, walks over subdirectories recursively, returning all
#   files in the tree.
func find_files(
	dirpath := "", patterns := PoolStringArray(), is_recursive := false, do_skip_hidden := true
) -> PoolStringArray:
	var file_paths := PoolStringArray()
	var directory := Directory.new()

	if not directory.dir_exists(dirpath):
		printerr("The directory does not exist: %s" % dirpath)
		return file_paths
	if not directory.open(dirpath) == OK:
		printerr("Could not open the following dirpath: %s" % dirpath)
		return file_paths

	directory.list_dir_begin(true, do_skip_hidden)
	var file_name := directory.get_next()
	var subdirectories := PoolStringArray()
	while file_name != "":
		if directory.current_is_dir() and is_recursive:
			var subdirectory := dirpath.plus_file(file_name)
			file_paths.append_array(find_files(subdirectory, patterns, is_recursive))
		else:
			for pattern in patterns:
				if file_name.match(pattern):
					file_paths.append(dirpath.plus_file(file_name))
		file_name = directory.get_next()

	directory.list_dir_end()
	return file_paths

# Saves text to a file.
func save_text(path := "", content := "") -> void:
	var dirpath := path.get_base_dir()
	var basename := path.get_file()
	if not dirpath:
		printerr("Couldn't save: the path %s is invalid." % path)
		return
	if not basename.is_valid_filename():
		printerr("Couldn't save: the file name, %s, contains invalid characters." % basename)
		return

	var directory := Directory.new()
	if not directory.dir_exists(dirpath):
		directory.make_dir(dirpath)

	var file := File.new()

	file.open(path, File.WRITE)
	file.store_string(content)
	file.close()
	print("Saved data to %s" % path)


# Parses a list of GDScript files and returns a list of dictionaries with the
# code reference data.
#
# If `refresh_cache` is true, will refresh Godot's cache and get fresh symbols.
func get_reference(files := PoolStringArray(), refresh_cache := false) -> Dictionary:
	var version := "n/a"
	if ProjectSettings.has_setting("application/config/version"):
		version = ProjectSettings.get_setting("application/config/version")  
	var data := {
		name = ProjectSettings.get_setting("application/config/name"),
		description = ProjectSettings.get_setting("application/config/description"),
		version = version,
		classes = []
	}
	var workspace = Engine.get_singleton('GDScriptLanguageProtocol').get_workspace()
	for file in files:
		if not file.ends_with(".gd"):
			continue
		if refresh_cache:
			workspace.parse_local_script(file)
		var symbols: Dictionary = workspace.generate_script_api(file)
		if symbols.empty():
			printerr('Failed generating api reference for "%s"' % file)
			continue
		if symbols.has("name") and symbols["name"] == "":
			symbols["name"] = file.get_file()
		parse_annotations(symbols)
		data["classes"].append(symbols)
	return data

# parse annotations to add extra metadata to the symbols then exclude them from
# the description string.
func parse_annotations(symbols: Dictionary) -> void:
	var description: String = (" " + symbols["description"]).dedent()
	
	for regex_match in annotations_regex.search_all(description):
		handle_annotation(symbols, regex_match.get_string("annotation"))

	symbols["description"] = remove_annotations(description)
	
	for meta in ["constants", "members", "signals", "methods", "static_functions"]:
		for metadata in symbols[meta]:
			var meta_description: String = (" " + metadata["description"]).dedent()
			for regex_match in annotations_regex.search_all(meta_description):
				handle_annotation(metadata, regex_match.get_string("annotation"))
			metadata["description"] = remove_annotations(meta_description)
	
	for sub_class in symbols["sub_classes"]:
		parse_annotations(sub_class)

func remove_annotations(description: String) -> String:
	return annotations_regex.sub(description, "\n", true).strip_edges()

func handle_annotation(symbols: Dictionary, annotation: String) -> void:
	var entry: PoolStringArray = annotation.split(":", true, 1)
	var name: String = entry[0]
	var value: String = entry[1] if entry.size() > 1 else ""
	value = value.trim_prefix("(").trim_suffix(")")
	
	match name:
		"doc-hide":
			symbols["hidden"] = true
		"doc-show":
			symbols["show"] = true
		"doc-deprecated":
			symbols["deprecated"] = true
		"doc-override-return":
			symbols["return_type"] = value
		"doc-override-param-default":
			var parameter_entry: PoolStringArray = value.split(";", true, 1)
			var index: int = int(parameter_entry[0])
			var default_value: String = parameter_entry[1]
			symbols["arguments"][index]["default_value"] = ArgumentDefault.new(default_value)
		"doc-qualifiers":
			symbols["qualifiers"] = []
			var qualifiers = value.split(",", false)
			for qualifier in qualifiers:
				qualifier = qualifier.to_lower()
				if qualifier in QUALIFIERS:
					symbols["qualifiers"].append(qualifier)
				else:
					printerr("'%s' is not a valid method qualifier" % qualifier)

func print_pretty_json(reference: Dictionary) -> String:
	return JSON.print(reference, "  ")

class ArgumentDefault:
	
	var default: String
	func _init(default_value: String) -> void:
		default = default_value
	
	func _to_string() -> String:
		return default
