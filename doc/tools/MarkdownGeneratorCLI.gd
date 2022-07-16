tool
extends SceneTree
# Finds and generates a code reference from gdscript files formatted wtih Makrdown.

const CLI: Script = preload("./util/CLI.gd")
const MarkdownGenerator: Script = preload("./MarkdownGenerator.gd").MarkdownGenerator

var generator := MarkdownGenerator.new()

# key-value pair of command line arguments
var cmdline_arg: Dictionary = CLI.parse_cmdline_args()

func _init() -> void:
	var collector = generator.collector
	
	if cmdline_arg.has("godot_docs"):
		generator.godot_docs_version = str(cmdline_arg["godot_docs"])
	
	if cmdline_arg.has("paths"):
		collector.directories = cmdline_arg["paths"].split(";", false)
		
	if cmdline_arg.has("recursive"):
		collector.is_recursive = cmdline_arg["recursive"]
	
	if cmdline_arg.has("patterns"):
		collector.patterns = cmdline_arg["patterns"].split(";", false)
	
	if cmdline_arg.has("output"):
		generator.output = cmdline_arg["output"]
	
	var refresh_cache: bool = cmdline_arg.has("refresh")
	
	generator.generate_markdown(refresh_cache)
	
	quit()
