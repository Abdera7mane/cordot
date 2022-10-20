class_name RoleEditAction extends RoleAction

var _role_id: int setget __set

# Constructs a new `RoleEditAction` instance.
func _init(
	rest: DiscordRESTMediator, guild_id: int, role_id: int
).(rest, guild_id) -> void:
	_method = "edit_guild_role"
	
	_role_id = role_id

# Edits the role.
#
# doc-qualifiers:coroutine
# doc-override-return:Role
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "RoleEditAction"

func _get_arguments() -> Array:
	var arguments: Array = ._get_arguments()
	arguments.insert(1, _role_id)
	return arguments

func __set(_value) -> void:
	pass

