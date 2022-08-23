# doc-hide
class_name IntegrationPacketshandler extends PacketHandler

const PACKETS: Dictionary = {
	"GUILD_INTEGRATIONS_UPDATE": "_on_guild_integration_update",
	"INTEGRATION_CREATE":  "_on_integration_create",
	"INTEGRATION_UPDATE": "_on_integration_update",
	"INTEGRATION_DELETE": "_on_integration_delete",
	"WEBHOOKS_UPDATE": "_on_webhooks_update",
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

# warning-ignore:unused_argument
func _on_guild_integration_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_integration_create(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_integration_update(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_integration_delete(fields: Dictionary) -> void:
	pass

# warning-ignore:unused_argument
func _on_webhooks_update(fields: Dictionary) -> void:
	pass

func get_class() -> String:
	return "IntegrationPacketshandler"
