tool
extends EditorScript
# Finds and generates a code reference from gdscript files.
#
# To use this tool:
#
# - Place this script and Collector.gd in your Godot project folder.
# - Open the script in the script editor.
# - Modify the properties below to control the tool's behavior.
# - Go to File -> Run to run the script in the editor.


func _run() -> void:
#	var annotations: PoolStringArray = [
#		"warnings-disable",
#		"doc-hide"
#	]
#	var annotations_with_value: PoolStringArray = [
#		"warning-ignore(-all)?",
#		"doc-override-return",
#		"doc-override-param-default",
#		"doc-qualifiers"
#	]
#	var pattern := "(^|\\n)(?<annotation>(%s)|(%s):\\w+)\\s*($|\\n)" % [
#		annotations.join("|"),
#		annotations_with_value.join("|")
#	]
#	var annotations_regex := RegEx.new()
#	var error := annotations_regex.compile(pattern)
#
#	print(annotations_regex.sub("   Registers an application command with the help of a command `builder` object\n If a `guild_id` is provided the command will only be registered on that guild,\n otherwise the command will be registered globally. The method should be called\n one time only in the whole bot life cycle, calling this with an already\n registered command will override its configuration.\n\n doc-qualifiers:coroutine\n doc-jide:d".dedent(), "\n"))
#	return
	ReferenceCollector.new().generate_api_reference()

class ReferenceCollector:
	const Collector: Script = preload("./Collector.gd")
	
	var collector := Collector.new()
	# A list of directories to collect files from.
	var directories := ["res://addons/cordot"]
	# If true, explore each directory recursively
	var is_recursive: = true
	# A list of patterns to filter files.
	var patterns := ["*.gd"]
	# Output path to save the class reference.
	var save_path := "res://reference.json"
	
	func collect_api_reference(refresh_cache: bool = false) -> Dictionary:
		var files := PoolStringArray()
		for dir_path in directories:
			files.append_array(collector.find_files(dir_path, patterns, is_recursive))
		return collector.get_reference(files, refresh_cache)

	func generate_api_reference(refresh_cache: bool = false) -> void:
		print("Generating API reference...")
		var json: String = collector.print_pretty_json(collect_api_reference(refresh_cache))
		collector.save_text(save_path, json)
		print("Completed !")
