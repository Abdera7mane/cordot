class_name GuildScheduledEvent extends DiscordEntity


enum PrivacyLevel {
	GUILD_ONLY = 2
}

enum EntityType {
	STAGE_INSTANCE = 1,
	VOICE          = 2,
	EXTERNAL       = 3
}

enum EventStatus {
	SCHEDULED = 1,
	ACTIVE    = 2,
	COMPLETED = 3,
	CANCELED  = 4,
}

var guild_id: int
var channel_id: int
var creator_id: int
var name: String
var description: String
var start_time: int
var end_time: int
var privacy_level: int
var status: int
var creator: User
var user_count: int
var entity_id: int
var entity_type: int
var entity_metadata: ScheduledEventMetadata

func _init(data: Dictionary) -> void:
	super(data["id"])
	guild_id = data["guild_id"]
	channel_id = data.get("channel_id", 0)
	creator_id = data.get("creator_id", 0)
	name = data["name"]
	description = data.get("description", "")
	start_time = data.get("start_time", 0)
	end_time = data.get("end_time", 0)
	privacy_level = data["privacy_level"]
	status = data["status"]
	creator = data.get("creator")
	entity_id = data.get("entity_id", 0)
	entity_type = data["entity_type"]
	entity_metadata = data.get("entity_metadata")

func get_class() -> String:
	return "GuildScheduledEvent"
