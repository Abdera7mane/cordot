class_name DiscordActivity

enum Flags {
	INSTANCE                    = 1 << 0,
	JOIN                        = 1 << 1,
	SPECTATE                    = 1 << 2,
	JOIN_REQUEST                = 1 << 3,
	SYNC                        = 1 << 4,
	PLAY                        = 1 << 5,
	PARTY_PRIVACY_FRIENDS       = 1 << 6,
	PARTY_PRIVACY_VOICE_CHANNEL = 1 << 7,
	EMBEDDED                    = 1 << 8,
}

enum Type {
	GAME,
	STREAMING,
	LISTENING,
	CUSTOM    = 4,
	COMPETING = 5
}

var name: String                   setget __set
var type: int                      setget __set
var url: String                    setget __set
var created_at: int                setget __set
var timestamps: ActivityTimestamps setget __set
var application_id: int            setget __set
var details: String                setget __set
var state: String                  setget __set
var emoji: Emoji                   setget __set
var party: ActivityParty           setget __set
var assets: ActivityAssets         setget __set
var secrets: ActivitySecrets       setget __set
var instance: bool                 setget __set
var flags: BitFlag                 setget __set
var buttons: Array                 setget __set

func _init(data: Dictionary) -> void:
	flags = BitFlag.new(Flags)
	
	name = data["name"]
	type = data["type"]
	url = data.get("url", "")
	created_at = data["created_at"]
	timestamps = data.get("timestamps")
	application_id = data.get("application_id", 0)
	details = data.get("details", "")
	state = data.get("state", "")
	emoji = data.get("emoji")
	party = data.get("party")
	assets = data.get("assets")
	secrets = data.get("secrets")
	instance = data.get("instance", false)
	flags.flags = data.get("flags", 0)
	buttons = data.get("buttons", [])

func to_dict() -> Dictionary:
	var data: Dictionary = {
		name = self.name,
		type = self.type,
		created_at = self.created_at,
		instance = self.instance,
		flags = self.flags.flags
	}
	
	if not url.empty():
		data["url"] = url
	if not state.empty():
		data["state"] = state
	if not details.empty():
		data["details"] = details
	if emoji:
		data["emoji"] = emoji.to_dict()
	if timestamps:
		data["timestamps"] = timestamps.to_dict()
	if assets:
		data["assets"] = assets.to_dict()
	if party:
		data["party"] = party.to_dict()
	if secrets:
		data["secrets"] = secrets.to_dict()
	
	return data

func get_class() -> String:
	return "DiscordActivity"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
