class_name Invite

enum TargetType {
	STREAM               = 1,
	EMBEDDED_APPLICATION = 2
}

var code: String
var guild: Guild
var channel: PartialChannel
var inviter: User
var target_type: int
var target_user: User
var target_application: DiscordApplication
var presence_count: int
var member_count: int
var expires_at: int
var stage_instance: StageInstanceInvite
var scheduled_event: GuildScheduledEvent

func _init(data: Dictionary) -> void:
	code = data["code"]
	guild = data.get("guild")
	channel = data.get("channel")
	inviter = data.get("inviter")
	target_type = data.get("target_type", 0)
	target_user = data.get("target_user")
	target_application = data.get("target_application")
	presence_count = data.get("presence_count", 0)
	member_count = data.get("member_count", 0)
	expires_at = data.get("expires_at", 0)
	stage_instance = data.get("stage_instance")
	scheduled_event = data.get("scheduled_event")

func get_class() -> String:
	return "Invite"
