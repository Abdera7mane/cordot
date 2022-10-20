# Action to edit the current guild member.
class_name CurrentMemberEditAction extends DiscordRESTAction

var _guild_id: int    setget __set
var _data: Dictionary setget __set
var _reason: String   setget __set

# Constructs a new `CurrentMemberEditAction` instance.
func _init(rest: DiscordRESTMediator, guild_id: int).(rest) -> void:
	_type = DiscordREST.GUILD
	_method = "edit_crurrent_member"

	_guild_id = guild_id

# Edits the current member profile.
#
# doc-qualifiers:coroutine
# doc-override-return:Member
func submit():
	return _submit()

# Sets the current member nickname. Requires `CHANGE_NICKNAME` permission.
func set_nickname(nickname: String) -> CurrentMemberEditAction:
	_data["nick"] = nickname
	return self

# Sets the reason for editing the current member.
func reason(why: String) -> CurrentMemberEditAction:
	_reason = why
	return self

# doc-hide
func get_class() -> String:
	return "CurrentMemberEditAction"

func _get_arguments() -> Array:
	return [_guild_id, _data, _reason]

func __set(_value) -> void:
	pass

