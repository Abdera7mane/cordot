class_name UserManager extends BaseDiscordEntityManager.BaseUserManager

func _init(manager: BaseDiscordEntityManager).(manager) -> void:
	pass

func construct_user(data: Dictionary) -> User:
	var arguments: Dictionary = {
		id = data["id"] as int,
		username = data.get("username", ""),
		discriminator = data.get("discriminator", 0) as int,
		avatar_hash = GDUtil.dict_get_or_default(data, "avatar", ""),
		is_bot = data.get("bot", false),
		is_system = data.get("system", false),
		mfa_enabled = data.get("mfa_enabled", false),
		banner_hash = GDUtil.dict_get_or_default(data, "avatar", ""),
		accent_color = Color(GDUtil.dict_get_or_default(data, "accent_color", 0)),
		locale = data.get("locale", "unkown"),
		verified = data.get("verified", false),
		email = GDUtil.dict_get_or_default(data, "email", ""),
		flags = data.get("flags", User.Flags.NONE),
		premium_type = data.get("premium_type", User.PremiumType.NONE),
		public_flags = data.get("public_flags", User.Flags.NONE),
	}
	
	var user = User.new(arguments)
	user.set_meta("container", self.get_manager().container)
	user.set_meta("partial", not data.has("username"))
	
	return user

func construct_presence(data: Dictionary) -> Presence:
	var user: User = self.get_manager().get_or_construct_user(data["user"])
	
	var activities: Array = []
	for activity_data in data["activities"]:
		activities.append(self.construct_activity(activity_data))
	
	var client_status: Dictionary = data["client_status"]
	var platforms: PoolIntArray = []
	if client_status.has("desktop"):
		platforms.append(Presence.Platforms.DESKTOP)
	if client_status.has("mobile"):
		platforms.append(Presence.Platforms.MOBILE)
	if client_status.has("web"):
		platforms.append(Presence.Platforms.WEB)
	
	var arguments: Dictionary = {
		id = user.id,
		status = string_to_status(data["status"]),
		activities = activities,
		platforms = platforms
	}
	
	var presence: Presence = Presence.new(arguments)
	presence.set_meta("container", self.get_manager().container)
	
	return presence

func construct_activity(data: Dictionary) -> Activity:
	return null

func get_class() -> String:
	return "UserManager"

static func string_to_status(status: String) -> int:
	return Presence.Status.get(status.to_upper(), Presence.Status.OFFLINE)
