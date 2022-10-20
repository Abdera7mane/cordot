class_name GuildMemberEditAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _member_id: int   setget __set
var _data: Dictionary setget __set
var _reason: String   setget __set

func _init(
	rest: DiscordRESTMediator, guild_id: int, member_id: int
).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "edit_guild_member"
	
	_guild_id = guild_id
	_member_id = member_id

# Edits the guild member.
#
# doc-qualifiers:coroutine
# doc-override-return:Member
func submit():
	return _submit()

func set_nickname(nickmane: String) -> GuildMemberEditAction:
	nickmane = nickmane.strip_edges()
	if nickmane.empty():
		_data["nick"] = null
	else:
		_data["nick"] = nickmane
	return self

func set_roles(role_ids: Array) -> GuildMemberEditAction:
	_data["roles"] = role_ids
	return self

func mute(value: bool) -> GuildMemberEditAction:
	_data["mute"] = value
	return self

func deafen(value: bool) -> GuildMemberEditAction:
	_data["deaf"] = value
	return self

func move_to_channel(channel_id: int) -> GuildMemberEditAction:
	_data["channel_id"] = str(channel_id)
	return self

func timeout(until: int) -> GuildMemberEditAction:
	_data["communication_disabled_until"] = TimeUtil.unix_to_iso(until)
	return self

func remove_nickname() -> GuildMemberEditAction:
	return set_nickname("")

func clear_roles() -> GuildMemberEditAction:
	return set_roles([])

func remove_timeout() -> GuildMemberEditAction:
	_data["communication_disabled_until"] = null
	return self

func reason(why: String) -> GuildMemberEditAction:
	_reason = why
	return self

func get_class() -> String:
	return "GuildMemberEditAction"

func _get_arguments() -> Array:
	return [_guild_id, _member_id, _data, _reason]

func __set(_value) -> void:
	pass
