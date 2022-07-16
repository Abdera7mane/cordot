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
