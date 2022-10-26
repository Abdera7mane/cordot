# Action to update a message of a message component interaction.
class_name InteractionMessageUpdateAction extends MessageEditAction

var _interaction_id: int setget __set
var _token: String       setget __set

# Constructs a new `InteractionMessageEditAction` instance.
func _init(
	rest: DiscordRESTMediator, interaction_id: int, token: String
).(rest, 0, 0) -> void:
	_type = DiscordREST.INTERACTION
	_method = "create_response"
	
	_interaction_id = interaction_id
	_token = token

# Updates the message.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "InteractionMessageUpdateAction"

func _get_arguments() -> Array:
	return [
		_interaction_id, _token,
		{
			type = DiscordInteraction.Callback.UPDATE_MESSAGE,
			data = _get_message_data()
		}
	]

func __set(_value) -> void:
	pass
