tool
extends SceneTree # GDScriptLanguageProtocol singleton does not exist under MainLoop
# Finds and generates a code reference from gdscript files.

const CLI: Script = preload("./util/CLI.gd")
const ReferenceCollector: Script = preload("./ReferenceCollector.gd").ReferenceCollector

var collector := ReferenceCollector.new()

# key-value pair of command line arguments
var cmdline_arg: Dictionary = CLI.parse_cmdline_args()

func _init() -> void:
	if cmdline_arg.has("paths"):
		collector.directories = cmdline_arg["paths"].split(";", false)
		
	if cmdline_arg.has("recursive"):
		collector.is_recursive = cmdline_arg["recursive"]
	
	if cmdline_arg.has("patterns"):
		collector.patterns = cmdline_arg["patterns"].split(";", false)
	
	if cmdline_arg.has("output"):
		collector.save_path = cmdline_arg["output"]
	
	var refresh_cache: bool = cmdline_arg.has("refresh")
	
	collector.generate_api_reference(refresh_cache)
	
	quit()
