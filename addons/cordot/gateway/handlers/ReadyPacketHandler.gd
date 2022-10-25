# doc-hide
class_name ReadyPacketHandler extends PacketHandler

const PACKETS: Dictionary = {
	"READY": "_on_ready",
	"GUILD_CREATE": "_on_guild_created",
	"GUILD_DELETE": "_on_guild_deleted"
}

var _connection_state: ConnectionState
var _entity_manager: BaseDiscordEntityManager

var ready: bool
var unavailable_guilds: Array

func _init(state: ConnectionState, manager: BaseDiscordEntityManager) -> void:
	_connection_state = state
	_entity_manager = manager

func remove_unvailable_guild(id: int) -> void:
	if id in unavailable_guilds:
		unavailable_guilds.erase(id)
		check_ready()

func check_ready() -> void:
	var intents: BitFlag = BitFlag.new(GatewayIntents.get_script_constant_map())
	var wait_for_guilds = intents.put(_connection_state.intents).has(
		GatewayIntents.GUILDS
	)
	
	if unavailable_guilds.empty() or not wait_for_guilds:
		ready = true
		var self_user: User = _entity_manager.get_self()
		self.emit_signal("transmit_event", "client_ready", [self_user])

func get_packets() -> Dictionary:
	return PACKETS

func _on_ready(fields: Dictionary) -> void:
	ready = false
	unavailable_guilds.clear()

	var user: User = _entity_manager.get_or_construct_user(fields["user"])
	_entity_manager.container.bot_id = user.id
	_connection_state.session_id = fields["session_id"]
	for guild_data in fields["guilds"]:
		var guild: Guild = _entity_manager.get_or_construct_guild(guild_data)
		unavailable_guilds.append(guild.id)
	
	var application: DiscordApplication = _entity_manager.application_manager\
										.construct_application(fields["application"])
	_entity_manager.container.applications[application.id] = application
	_entity_manager.container.application_id = application.id
	
	check_ready()

func _on_guild_created(fields: Dictionary) -> void:
	if not ready:
		remove_unvailable_guild(fields["id"] as int)

func _on_guild_deleted(fields: Dictionary) -> void:
	if not ready:
		remove_unvailable_guild(fields["id"] as int)
