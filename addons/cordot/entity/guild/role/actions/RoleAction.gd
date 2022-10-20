class_name RoleAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _data: Dictionary setget __set
var _reason: String   setget __set

# doc-hide
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	
	_guild_id = guild_id

# Executes the action.
#
# doc-qualifiers:coroutine
# doc-override-return:Role
func submit():
	return _submit()

# Sets the role name.
func set_name(name: String) -> RoleAction:
	_data["name"] = name
	return self

# Sets the role's permission flags.
func set_permissions(flags: int) -> RoleAction:
	_data["permissions"] = flags
	return self

# Sets the role color.
func set_color(color: Color) -> RoleAction:
	_data["color"] = color
	return self

# Whether to display the role seperately in the sidebar.
func set_hoist(value: bool) -> RoleAction:
	_data["hoist"] = value
	return self

# Sets the role's icon image.
# Requires the guild to have `ROLE_ICONS` feature.
func set_icon(image: Image) -> RoleAction:
	_data["icon"] = image
	return self

# Sets hte role's unicode emoji.
# Requires the guild to have `ROLE_ICONS` feature.
func set_unicode_emoji(unicode: String) -> RoleAction:
	_data["unicode_emoji"] = unicode
	return self

# Whether to allow the role to be mentioned.
func mentionable(value: bool) -> RoleAction:
	_data["mentionable"] = value
	return self

# Sets the reason for executing this action.
func reason(why: String) -> RoleAction:
	_reason = why
	return self

func _get_arguments() -> Array:
	var data: Dictionary = _data.duplicate()
	if data.has("color"):
		var color: Color = data["color"]
		color.a = 0
		data["color"] = color.to_abgr32()
	var icon: Image = data.get("icon")
	if icon:
		data["icon"] = Marshalls.raw_to_base64(icon.get_data())
	return [_guild_id, data, _reason]

func __set(_value) -> void:
	pass

