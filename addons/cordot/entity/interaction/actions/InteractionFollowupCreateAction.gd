class_name InteractionFollowupCreateAction extends MessageCreateAction

var _application_id: int setget __set
var _token: String       setget __set

# Constructs a new `InteractionFollowupCreateAction` instance.
func _init(
	rest: DiscordRESTMediator, application_id: int, token: String
).(rest, 0) -> void:
	_type = DiscordREST.INTERACTION
	_method = "create_response"
	
	_application_id = application_id
	_token = token

# doc-hide
func get_class() -> String:
	return "InteractionFollowupCreateAction"

func _get_arguments() -> Array:
	return [_application_id, _token, _get_message_data()]

func __set(_value) -> void:
	pass
