class_name GuildEmoji extends Emoji

var guild_id: int
var guild: Guild:
	get: return get_container().guilds.get(guild_id)
var roles_ids: Array
var roles: Array:
	get = get_roles
var user_id: int
var user: User:
	get: return get_container().users.get(user_id)
var is_managed: bool
var is_animated: bool
var available: bool

func _init(data: Dictionary) -> void:
	super(data)
	guild_id = data["guild_id"]
	user_id = data["user_id"]
	is_managed = data.get("is_managed", false)
	is_animated = data.get("is_animated", false)
	available = data.get("available", false)

func get_mention() -> String:
	return ("<a:%s:%d>" if self.is_animated else "<:%s:%d>") % [self.name, self.id]

func get_roles() -> Array:
	var _roles: Array
	for role_id in self.roles_ids:
		var role: Role = self.guild.get_role(role_id)
		if role:
			_roles.append(role)
	return _roles

func url_encoded() -> String:
	return ("a:%d" % self.id).uri_encode()

func get_class() -> String:
	return "Guild.GuildEmoji"

func _clone_data() -> Array:
	return [{
		id = self.id,
		name = self.name,
		guild_id = self.guild_id,
		roles_ids = self.roles_ids.duplicate(),
		user_id = self.user_id,
		permissions = self.permissions,
		is_managed = self.is_managed,
		is_animated = self.is_animated,
		available = self.available,
	}]
