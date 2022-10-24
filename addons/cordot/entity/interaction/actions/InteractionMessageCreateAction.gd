# Action to edit an interaction original message response.
class_name InteractionMessageCreateAction extends MessageCreateAction

var _interaction_id: int setget __set
var _token: String       setget __set

# Constructs a new `InteractionMessageCreateAction` instance.
func _init(
	rest: DiscordRESTMediator, interaction_id: int, token: String
).(rest, 0) -> void:
	_type = DiscordREST.INTERACTION
	_method = "create_response"
	
	_interaction_id = interaction_id
	_token = token

# Creates the message response to the interaction.
# 
# doc-qualifiers:coroutine
# doc-return-override:bool
func submit():
	return _submit()

# doc-hide
func get_class() -> String:
	return "InteractionMessageCreateAction"

func _get_arguments() -> Array:
	return [
		_interaction_id, _token,
		{
			type = DiscordInteraction.Callback.CHANNEL_MESSAGE,
			data = _get_message_data()
		}
	]

func __set(_value) -> void:
	pass
