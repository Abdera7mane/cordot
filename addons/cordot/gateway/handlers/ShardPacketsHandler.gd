# doc-hide
class_name ShardPacketsHandler extends PacketHandler

signal session_established(session_id, resume_gateway_url)
signal ready()
signal resumed()

const PACKETS: Dictionary = {
	"READY": "_on_ready",
	"RESUMED": "_on_resume",
	"GUILD_CREATE": "_on_guild_created",
	"GUILD_DELETE": "_on_guild_deleted"
}

var _intents: BitFlag
var _ready: bool
var _unavailable_guilds: Array

func _init(intents: int) -> void:
	_intents = BitFlag.new(
		GatewayIntents.get_script_constant_map()
	).put(intents)

func remove_unvailable_guild(id: String) -> void:
	_unavailable_guilds.erase(id)
	check_ready()

func check_ready() -> void:
	var wait_for_guilds = _intents.has(GatewayIntents.GUILDS)
	
	if _unavailable_guilds.empty() or not wait_for_guilds:
		_ready = true
		_unavailable_guilds.clear()
		emit_signal("ready")

func get_packets() -> Dictionary:
	return PACKETS

func _on_ready(fields: Dictionary) -> void:
	_ready = false
	_unavailable_guilds.clear()
	
	emit_signal(
		"session_established",
		fields["session_id"], fields["resume_gateway_url"]
	)
	
	for guild_data in fields["guilds"]:
		_unavailable_guilds.append(guild_data["id"])
	
	check_ready()

func _on_resume(_fields: Dictionary) -> void:
	emit_signal("resumed")

func _on_guild_created(fields: Dictionary) -> void:
	if not _ready:
		remove_unvailable_guild(fields["id"])

func _on_guild_deleted(fields: Dictionary) -> void:
	if not _ready:
		remove_unvailable_guild(fields["id"])
