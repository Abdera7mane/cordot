# A user's presence is their current state on Discord.
# It gets updated on `DiscordClient.presence_updated` event.
class_name Presence extends DiscordEntity

# User status enum.
enum Status {
	IDLE,
	DND,
	ONLINE,
	INVISIBLE,
	OFFLINE
}

# User's platform-dependent status enum.
enum Platforms {
	DESKTOP = 1 << 0,
	MOBILE  = 1 << 1,
	WEB     = 1 << 2
}

# User's current status.
var status: int        setget __set

# User's current activities.
var activities: Array  setget __set

# The platform the user is connected on.
var platforms: BitFlag setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	activities = data["activities"]
	status = data["status"]
	platforms = data["platforms"]
	platforms = BitFlag.new(Platforms)

# Check whether the user is connected on the desktop client.
func on_desktop() -> bool:
	return platforms.DESKTOP

# Check whether the user is connected on the mobile client.
func on_mobile() -> bool:
	return platforms.MOBILE

# Check whether the user is connected on the web client.
func on_web() -> bool:
	return platforms.WEB

# doc-hide
func get_class() -> String:
	return "Presence"

func __set(_value) -> void:
	pass

# warning-ignore:shadowed_variable
# Converts a `Status` enum value to their respective string name.
static func status_to_string(status: int) -> String:
	return Status.keys()[clamp(0, status, Status.size())].to_lower()

# Constructs a game activty.
static func playing(game: String) -> DiscordActivity:
	return create_activity(game, DiscordActivity.Type.GAME)

# Constructs a listening activty.
static func listening(to: String) -> DiscordActivity:
	return create_activity(to, DiscordActivity.Type.LISTENING)

# Constructs a streaming activty in which `what` is the title
# and `url` is a Twitch or YouTube url.
static func streaming(what: String, url: String) -> DiscordActivity:
	return create_activity(what, DiscordActivity.Type.STREAMING, url)

# Constructs an activity where `type` takes an `DiscordActivity.Type` 
# and `name` is the activity name.
# `stream_url` is specific to `DiscordActivity.Type.STREAMING` activity type.
static func create_activity(name: String, type: int, stream_url: String = "") -> DiscordActivity:
	var data: Dictionary = {
		"name": name,
		"type": type,
		"created_at": OS.get_unix_time()
	}
	
	if type == DiscordActivity.Type.STREAMING:
		data["url"] = stream_url
	return DiscordActivity.new(data)
