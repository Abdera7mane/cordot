class_name DiscordInteractionData

var command_id: int                          
var name: String                             
var type: int                                
var resolved: DiscordInteractionResolvedData 
var options: Array                           
var custom_id: String                        
var component_type: int                      
var values: Array                            
var target_id: int                           
var components: Array                        

func _init(data: Dictionary) -> void:
	command_id = data["command_id"]
	name = data["name"]
	type = data["type"]
	resolved = data.get("resolved")
	options = data.get("options", [])
	custom_id = data.get("custom_id", "")
	component_type = data.get("component_type", 0)
	values = data.get("values", [])
	target_id = data.get("target_id", 0)
	components = data.get("components", [])

func get_class() -> String:
	return "DiscordInteractionData"

func __set(_value) -> void:
	pass
