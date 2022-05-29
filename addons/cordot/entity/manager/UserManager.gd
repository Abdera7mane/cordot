class_name UserManager extends BaseUserManager

var entity_manager: WeakRef

func _init(manager: BaseDiscordEntityManager) -> void:
	self.entity_manager = weakref(manager)

func get_manager() -> BaseDiscordEntityManager:
	return entity_manager.get_ref()

func construct_user(data: Dictionary) -> User:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var user = User.new(parse_user_payload(data))
	user.set_meta("container", manager.container)
	user.set_meta("rest", manager.rest_mediator)
	user.set_meta("partial", not data.has("username"))
	
	return user

func construct_presence(data: Dictionary) -> Presence:
	var manager: BaseDiscordEntityManager = get_manager()
	var user: User = manager.get_or_construct_user(data["user"])
	
	var activities: Array = []
	for activity_data in data["activities"]:
		activities.append(construct_activity(activity_data))
	
	var client_status: Dictionary = data["client_status"]
	var platforms: BitFlag = BitFlag.new(Presence.Platforms)
	platforms.DESKTOP = client_status.has("desktop")
	platforms.MOBILE = client_status.has("mobile")
	platforms.WEB = client_status.has("web")
	
	var arguments: Dictionary = {
		id = user.id,
		status = string_to_status(data["status"]),
		activities = activities,
		platforms = platforms
	}
	
	var presence: Presence = Presence.new(arguments)
	presence.set_meta("container", manager.container)
	
	return presence

func construct_activity(data: Dictionary) -> DiscordActivity:
	var arguments: Dictionary = {
		name = data["name"],
		type = data["type"],
		url = Dictionaries.get_non_null(data, "url", ""),
		created_at = data["created_at"],
		timestamps = construct_activity_timestamps(data["timestamps"]) if data.has("timestamps") else null,
		application_id = data.get("application_id", 0) as int,
		details = data.get("details", ""),
		party = construct_activity_party(data["party"]) if data.has("party") else null,
		assets = construct_activity_assets(data["assets"]) if data.has("assets") else null,
		secrets = construct_activity_secrets(data["secrets"]) if data.has("secrets") else null,
		instance = data.get("instance", false),
		flags = data.get("flags", 0)
	}
	
	if data.has("emoji"):
		arguments["emoji"] = get_manager().get_or_construct_emoji(data["emoji"])
	
	var buttons: Array = []
	for button_data in data.get("buttons", []):
		buttons.append(construct_activity_button(button_data))
	arguments["buttons"] = buttons
	
	return DiscordActivity.new(arguments)

func construct_activity_timestamps(data: Dictionary) -> ActivityTimestamps:
	return ActivityTimestamps.new({
		start = data.get("start", 0),
		end = data.get("end", 0)
	})

func construct_activity_party(data: Dictionary) -> ActivityParty:
	return ActivityParty.new({
		id = data.get("id", ""),
		size = data.get("size", [])
	})

func construct_activity_assets(data: Dictionary) -> ActivityAssets:
	return ActivityAssets.new({
		large_image = data.get("large_image", ""),
		large_text = data.get("large_text", ""),
		small_image = data.get("small_image", ""),
		small_text = data.get("small_text", "")
	})

func construct_activity_secrets(data: Dictionary) -> ActivitySecrets:
	return ActivitySecrets.new({
		join = data.get("join", ""),
		spectate = data.get("spectate", ""),
		instanced_match = data.get("match", "")
	})

func construct_activity_button(data: Dictionary) -> ActivityButton:
	return ActivityButton.new({
		label = data["label"],
		url = data["url"]
	})

func update_user(user: User, data: Dictionary) -> void:
	user._update(parse_user_payload(data))

func parse_user_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {id = data["id"] as int}
	
	if data.has("username"):
		parsed_data["username"] = data["username"]
	if data.has("discriminator"):
		parsed_data["discriminator"] = data["discriminator"] as int
	if data.has("avatar"):
		parsed_data["avatar_hash"] = Dictionaries.get_non_null(data, "avatar", "")
	if data.has("bot"):
		parsed_data["is_bot"] = data["bot"]
	if data.has("system"):
		parsed_data["is_system"] = data["system"]
	if data.has("mfa_enabled"):
		parsed_data["mfa_enabled"] = data["mfa_enabled"]
	if data.has("banner"):
		parsed_data["banner_hash"] = Dictionaries.get_non_null(data, "banner", "")
	if data.has("accent_color"):
		var color: Color = Colors.from_rgb24(Dictionaries.get_non_null(data, "accent_color", 0))
		parsed_data["accent"] = color
	if data.has("local"):
		parsed_data["local"] = data["local"]
	if data.has("verified"):
		parsed_data["verified"] = data["verified"]
	if data.has("email"):
		parsed_data["email"] = Dictionaries.get_non_null(data, "email", "")
	if data.has("flags"):
		parsed_data["flags"] = data["flags"]
	if data.has("premium_type"):
		parsed_data["premium_type"] = data["premium_type"]
	if data.has("public_flags"):
		parsed_data["public_flags"] = data["public_flags"]
	
	return parsed_data

func get_class() -> String:
	return "UserManager"

static func string_to_status(status: String) -> int:
	return Presence.Status.get(status.to_upper(), Presence.Status.OFFLINE)
