# Action to create roles for a guild.
class_name RoleCreateAction extends RoleAction

# Constructs a new `RoleCreateAction` instance.
func _init(
	rest: DiscordRESTMediator, guild_id: int
).(rest, guild_id) -> void:
	_method = "create_guild_role"

# Creates the role.
#
# doc-qualifiers:coroutine
# doc-override-return:Role
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "RoleCreateAction"

