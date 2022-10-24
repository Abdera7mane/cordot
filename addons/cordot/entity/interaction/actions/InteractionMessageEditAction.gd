# Action to edit an interaction original message response.
class_name InteractionMessageEditAction extends MessageEditAction

var _application_id: int setget __set
var _token: String       setget __set

# Constructs a new `InteractionMessageEditAction` instance.
func _init(
	rest: DiscordRESTMediator, application_id: int, token: String
).(rest, 0, 0) -> void:
	_type = DiscordREST.INTERACTION
	_method = "edit_original_response"
	
	_application_id = application_id
	_token = token

# doc-hide
func get_class() -> String:
	return "InteractionMessageEditAction"

func _get_arguments() -> Array:
	return [_application_id, _token, _get_message_data()]

func __set(_value) -> void:
	pass
