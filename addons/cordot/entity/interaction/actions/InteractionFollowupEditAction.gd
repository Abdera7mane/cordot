class_name InteractionFollowupEditAction extends MessageEditAction

var _application_id: int setget __set
var _token: String       setget __set

# Constructs a new `InteractionFollowupEditActio` instance.
func _init(
	rest: DiscordRESTMediator, application_id: int,
	token: String, followup_id: int
).(rest, 0, followup_id) -> void:
	_type = DiscordREST.INTERACTION
	_method = "edit_followup_message"
	
	_application_id = application_id
	_token = token

# doc-hide
func get_class() -> String:
	return "InteractionFollowupEditAction"

func _get_arguments() -> Array:
	return [_application_id, _token, _message_id, _get_message_data()]

func __set(_value) -> void:
	pass
