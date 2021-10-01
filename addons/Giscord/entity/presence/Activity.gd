class_name Activity

enum Flag {
	NONE,
	INSTANCE     = 1 << 0,
	JOIN         = 1 << 1,
	SPECTATE     = 1 << 2,
	JOIN_REQUEST = 1 << 3,
	SYNC         = 1 << 4,
	PLAY         = 1 << 5,
}

enum Type {
	GAME,
	STREAMING,
	LISTENING,
	CUSTOM    = 4,
	COMPETING = 5
}

var name: String           setget __set
var type: int              setget __set
var url: String            setget __set
var created_at: int        setget __set
var timestamps: Timestamps setget __set
var application_id: int    setget __set
var details: String        setget __set
var state: String          setget __set
var emoji: Emoji           setget __set
var party: Party           setget __set
var assets: Assets         setget __set
var secrets: Secrets       setget __set
var instance: bool         setget __set
var flags: int             setget __set

func _init(data: Dictionary) -> void:
	name = data.name
	type = data.type
	url = data.get("url", "")
	created_at = data["created_at"]
	timestamps = data.get("timestamps")
	application_id = data.get("application_id", 0)
	details = data.get("details", "")
	state = data.get("state", "")
	emoji = null
	party = data.get("party")
	assets = data.get("assets")
	secrets = data.get("secrets")
	instance = data.get("instance", false)
	flags = data.get("flags", Flag.NONE)

func get_timestamp_start() -> int:
	return self.timestamps.start if self.timestamps else -1

func get_timestamp_end() -> int:
	return self.timestamps.end if self.timestamps else -1

func get_large_image() -> String:
	return self.assets.large_image if self.assets else ""

func get_large_text() -> String:
	return self.assets.large_text if self.assets else ""

func get_small_image() -> String:
	return self.assets.small_image if self.assets else ""

func get_small_text() -> String:
	return self.assets.small_text if self.assets else ""

func set_large_image(image_key: String) -> void:
	if not self.assets:
		self.assets = Assets.new()
	self.assets.large_image = image_key

func set_large_text(text: String) -> void:
	if not self.assets:
		self.assets = Assets.new()
	self.assets.large_text = text

func set_small_image(image_key: String) -> void:
	if not self.assets:
		self.assets = Assets.new()
	self.assets.small_image = image_key

func set_small_text(text: String) -> void:
	if not self.assets:
		self.assets = Assets.new()
	self.assets.small_text = text

func set_timestamp_start(start: int) -> void:
	if not self.timestamps:
		self.timestamps = Timestamps.new()
	self.timestamps.start = start

func set_timestamp_end(end: int) -> void:
	if (not self.timestamps):
		self.timestamps = Timestamps.new()
	self.timestamps.end = end

func clear_assets() -> void:
	self.assets = null

func clear_timestamp() -> void:
	self.timestamps = null

func to_dict() -> Dictionary:
	var data: Dictionary = {
		"name": self.name,
		"type": self.type,
		"created_at": self.created_at,
		"instance": true,
		"flags": self.flags
	}
	
	if not self.url.empty():
		data["url"] = url
	if not self.state.empty():
		data["state"] = self.state
	if not self.details.empty():
		data["details"] = self.details
	if self.emoji:
		data["emoji"] = self.emoji
	if self.timestamps:
		data["timestamps"] = self.timestamps.to_dict()
	if self.assets:
		data["assets"] = self.assets.to_dict()
	if self.party:
		data["party"] = self.party.to_dict()
	if self.secrets:
		data["secrets"] = self.secrets
	
	return data
func get_class() -> String:
	return "Activity"

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.id, self.get_instance_id()]

func __set(_value) -> void:
	GDUtil.protected_setter_printerr(self, get_stack())

class Timestamps:
	var start: int setget __set
	var end: int   setget __set

	func _init(_start: int = -1, _end: int = -1) -> void:
		start = _start
		end = _end
	
	func to_dict() -> Dictionary:
		var data: Dictionary = {}
		if (self.start > -1):
			data["start"] = self.start
		if (self.end > -1):
			data["end"] = self.end
		return data
	
	func __set(_value) -> void:
		GDUtil.protected_setter_printerr(self, get_stack())

class Party:
	var id: String         setget __set
	var size: PoolIntArray setget __set
	
	func _init(_id: String, _size: PoolIntArray) -> void:
		id = _id
		size = _size
	
	func to_dict() -> Dictionary:
		var data: Dictionary = {}
		if not self.id.empty():
			data["id"] = self.id
		var party_size: Array = []
		if size.size() > 0:
			party_size[0] = size[0]
		if size.size() > 1:
			party_size[1] = size[1]
		data["size"] = party_size
		return data
	
	func __set(_value) -> void:
		GDUtil.protected_setter_printerr(self, get_stack())

class Assets:
	var large_image: String setget __set
	var large_text: String  setget __set
	var small_image: String setget __set
	var small_text: String  setget __set
	
	func _init(
		_large_image: String = "", _large_text: String = "",
		_small_image: String = "", _small_text: String = "") -> void:
		large_image = _large_image
		large_text = _large_text
		small_image = _small_image
		small_text = _small_text
	
	func to_dict() -> Dictionary:
		var data: Dictionary = {}
		if (not self.large_image.empty()):
			data["large_image"] = self.large_image
		if (not self.large_text.empty()):
			data["large_text"] = self.large_text
		if (not self.small_image.empty()):
			data["small_image"] = self.small_image
		if (not self.small_text.empty()):
			data["small_text"] = self.small_text
		return data
	
	func __set(_value) -> void:
		GDUtil.protected_setter_printerr(self, get_stack())

class Secrets:
	var join: String            setget __set
	var spectate: String        setget __set
	var instanced_match: String setget __set
	
	func _init(_join: String, _spectate: String, _instanced_match: String) -> void:
		join = _join
		spectate = _spectate
		instanced_match = _instanced_match
	
	func to_dict() -> Dictionary:
		var data: Dictionary = {}
		if not self.join.empty():
			data["join"] = self.join
		if not self.large_text.empty():
			data["spectate"] = self.spectate
		if not self.instanced_match.empty():
			data["instanced_match"] = self.instanced_match
		return data
	
	func __set(_value) -> void:
		GDUtil.protected_setter_printerr(self, get_stack())
