class_name Presence extends DiscordEntity

enum Status {
	IDLE,
	DND,
	ONLINE,
	INVISIBLE,
	OFFLINE
}

enum Platforms {
	DESKTOP,
	MOBILE,
	WEB
}

var status: int             setget __set
var activities: Array       setget __set
var platforms: PoolIntArray setget __set, get_platforms

func _init(data: Dictionary).(data["id"]) -> void:
	activities = data["activities"]
	status = data["status"]
	platforms = data["platforms"]

func get_platforms() -> PoolIntArray:
	# Bad way to duplicate the array
	return PoolIntArray(Array(platforms))

func on_desktop() -> bool:
	return Platforms.DESKTOP in platforms

func on_mobile() -> bool:
	return Platforms.MOBILE in platforms

func on_web() -> bool:
	return Platforms.WEB in platforms

func get_class() -> String:
	return "Presence"

func __set(_value) -> void:
	.__set(_value)

# warning-ignore:shadowed_variable
static func status_to_string(status: int) -> String:
	return Status.keys()[clamp(0, status, Status.size())].to_upper()

static func playing(game: String) -> Activity:
	return create_activity(game, Activity.Type.GAME)

static func listening(to: String) -> Activity:
	return create_activity(to, Activity.Type.LISTENING)

static func streaming(what: String, url: String) -> Activity:
	return create_activity(what, Activity.Type.STREAMING, url)

static func create_activity(name: String, type: int, stream_url: String = "") -> Activity:
	var data: Dictionary = {
		"name": name,
		"type": type,
		"created_at": OS.get_unix_time()
	}
	
	if type == Activity.Type.STREAMING:
		data["url"] = stream_url
	return Activity.new(data)
