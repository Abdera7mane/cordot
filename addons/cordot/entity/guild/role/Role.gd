class_name Role extends MentionableEntity

var name: String
var color: Color
var hoist: bool
var position: int
var permissions: BitFlag
var is_managed: bool
var mentionable: bool
var tags: Tags
var guild_id: int
var guild: Guild:
	get: return get_container().guilds.get(guild_id)

func _init(data: Dictionary) -> void:
	super(data["id"])
	guild_id = data["guild_id"]
	permissions = BitFlag.new((Permissions as Script).get_script_constant_map())
	_update(data)

func get_mention() -> String:
	return "<@&%d>" % self.get_id()

func edit(data: RoleEditData) -> Role:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not edit role, missing MANAGE_ROLES permission")
		return await Awaiter.submit()
	return get_rest().request_async(
		DiscordREST.GUILD,
		"edit_guild_role", [guild_id, self.id, data.to_dict()]
	)

func delete() -> bool:
	var bot_id: int = get_container().bot_id
	var self_permissions: BitFlag = self.guild.get_member(bot_id).get_permissions()
	if not self_permissions.MANAGE_ROLES:
		push_error("Can not delete role, missing MANAGE_ROLES permission")
		await Awaiter.submit()
		return false
	return await get_rest().request_async(
		DiscordREST.GUILD,
		"delete_guild_role", [guild_id, self.id]
	)

func get_class() -> String:
	return "Guild.Role"

func _clone_data() -> Array:
	return [{
		id = self.id,
		name = self.name,
		guild_id = self.guild_id,
		hoist = self.hoist,
		position = self.position,
		permissions = self.permissions.flags,
		is_managed = self.is_managed,
		mentionable = self.mentionable,
		tags = self.tags.duplicate() if tags else null,
	}]

func _update(data: Dictionary) -> void:
	name = data.get("name", name)
	color = data.get("color", color)
	if color == Color.BLACK:
		color == Color.TRANSPARENT
	hoist = data.get("hoist", hoist)
	position = data.get("position", position)
	permissions.flags = data.get("permissions", permissions.flags)
	is_managed = data.get("is_managed", is_managed)
	mentionable = data.get("mentionable", mentionable)
	tags = data.get("tags", tags)

func __set(_value) -> void:
	pass

class Tags:
	var bot_id: int
	var integration_id: int
	var premium_subscriber: bool

	func _init(data: Dictionary) -> void:
		bot_id = data["bot_id"]
		integration_id = data["integration_id"]
		premium_subscriber = data["premium_subscriber"]

	func duplicate() -> Tags:
		return self.get_script().new({
			bot_id = self.bot_id,
			integration_id = self.integration_id,
			premium_subscriber = self.premium_subscriber
		})

	func get_class() -> String:
		return "Guild.Role.Tags"

	func _to_string() -> String:
		return "[%s:%d]" % [self.get_class(), self.get_instance_id()]
