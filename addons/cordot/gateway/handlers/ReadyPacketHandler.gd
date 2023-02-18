# doc-hide
class_name ReadyPacketHandler extends PacketHandler

const PACKETS: Dictionary = {
	"READY": "_on_ready"
}

var _entity_manager: BaseDiscordEntityManager

func _init(manager: BaseDiscordEntityManager) -> void:
	_entity_manager = manager

func get_packets() -> Dictionary:
	return PACKETS

func _on_ready(fields: Dictionary) -> void:
	var user: User = _entity_manager.get_or_construct_user(fields["user"])
	_entity_manager.container.bot_id = user.id
	for guild_data in fields["guilds"]:
		var _guild: Guild = _entity_manager.get_or_construct_guild(guild_data)
	
	var application: DiscordApplication = _entity_manager.application_manager\
									.construct_application(fields["application"])
	_entity_manager.container.applications[application.id] = application
	_entity_manager.container.application_id = application.id
