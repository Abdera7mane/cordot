class_name UserManager extends BaseDiscordEntityManager.BaseUserManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_user(data: Dictionary) -> User:
	var manager: BaseDiscordEntityManager = get_manager()
	
	var user = User.new(parse_user_payload(data))
	user.set_meta("container", manager.container)
	user.set_meta("rest", manager.rest_mediator)
	user.set_meta("partial", not data.has("username"))
	
	return user

func construct_presence(data: Dictionary) -> Presence:
	var user: User = self.get_manager().get_or_construct_user(data["user"])
	
	var activities: Array = []
	for activity_data in data["activities"]:
		activities.append(self.construct_activity(activity_data))
	
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
	presence.set_meta("container", self.get_manager().container)
	
	return presence

# warning-ignore:unused_argument
func construct_activity(data: Dictionary) -> DiscordActivity:
	return null

func update_user(user: User, data: Dictionary) -> void:
	user._update(parse_user_payload(data))

func parse_user_payload(data: Dictionary) -> Dictionary:
	var parsed_data: Dictionary = {
		id = data["id"] as int,
		username = data.get("username", ""),
		discriminator = data.get("discriminator", 0) as int,
		avatar_hash = Dictionaries.get_non_null(data, "avatar", ""),
	}
	
	if data.has("bot"):
		parsed_data["is_bot"] = data["bot"]
	if data.has("system"):
		parsed_data["is_system"] = data["system"]
	if data.has("mfa_enabled"):
		parsed_data["mfa_enabled"] = data["mfa_enabled"]
	if data.has("banner"):
		parsed_data["banner_hash"] = Dictionaries.get_non_null(data, "banner", "")
	if data.has("accent_color"):
		parsed_data["accent"] = Color(Dictionaries.get_non_null(data, "accent_color", 0))
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
