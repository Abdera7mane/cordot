class_name Presence extends DiscordEntity

enum Status {
	IDLE,
	DND,
	ONLINE,
	INVISIBLE,
	OFFLINE
}

enum Platforms {
	DESKTOP = 1 << 0,
	MOBILE  = 1 << 1,
	WEB     = 1 << 2
}

var status: int        setget __set
var activities: Array  setget __set
var platforms: BitFlag setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	activities = data["activities"]
	status = data["status"]
	platforms = data["platforms"]
	platforms = BitFlag.new(Platforms)

func on_desktop() -> bool:
	return platforms.DESKTOP

func on_mobile() -> bool:
	return platforms.MOBILE

func on_web() -> bool:
	return platforms.WEB

func get_class() -> String:
	return "Presence"

func __set(_value) -> void:
	pass

# warning-ignore:shadowed_variable
static func status_to_string(status: int) -> String:
	return Status.keys()[clamp(0, status, Status.size())].to_lower()

static func playing(game: String) -> DiscordActivity:
	return create_activity(game, DiscordActivity.Type.GAME)

static func listening(to: String) -> DiscordActivity:
	return create_activity(to, DiscordActivity.Type.LISTENING)

static func streaming(what: String, url: String) -> DiscordActivity:
	return create_activity(what, DiscordActivity.Type.STREAMING, url)

static func create_activity(name: String, type: int, stream_url: String = "") -> DiscordActivity:
	var data: Dictionary = {
		"name": name,
		"type": type,
		"created_at": OS.get_unix_time()
	}
	
	if type == DiscordActivity.Type.STREAMING:
		data["url"] = stream_url
	return DiscordActivity.new(data)
