# doc-hide
class_name InteractionPacketsHandler extends PacketHandler

const PACKETS: Dictionary = {
	"INTERACTION_CREATE": "_on_interaction_create",
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

func _on_interaction_create(fields: Dictionary) -> void:
	var interaction: DiscordInteraction 
	interaction = _entity_manager.interaction_manager.construct_interaction(fields)
	emit_signal("transmit_event", "interaction_created", [interaction])
