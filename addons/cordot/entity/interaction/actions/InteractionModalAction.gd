class_name InteractionModalAction extends DiscordRESTAction

# Maximum number ofcharacters in a modal custom id.
const MAX_ID_LENGTH: int = 100

# Maximum number of characters in a modal title.
const MAX_TITLE_LENGTH: int = 45

# Maximum number of components in single modal.
const MAX_COMPONENTS: int = 5

var _interaction_id: int setget __set
var _token: String       setget __set
var _custom_id: String   setget __set
var _title: String       setget __set
var _components: Array   setget __set

# Constructs a new `InteractionModalAction` instance.
func _init(
	rest: DiscordRESTMediator, interaction_id: int, token: String
).(rest) -> void:
	_type = DiscordREST.INTERACTION
	_method = "create_response"
	
	_interaction_id = interaction_id
	_token = token

# Shows a modal popup to the user.
# Return `true` on success.
#
# doc-qualifiers:coroutine
# doc-override-return:bool
func submit():
	return _submit()

# Sets a custom identifier to the modal.
func set_custom_id(id: String) -> InteractionModalAction:
	if id.length() > MAX_ID_LENGTH:
		push_error("Modal custom id max length is limited to %s" % MAX_ID_LENGTH)
	else:
		_custom_id = id
	return self

# Sets the modal title.
func set_title(title: String) -> InteractionModalAction:
	if title.length() > MAX_TITLE_LENGTH:
		push_error("Modal title max length is limited to %s" % MAX_TITLE_LENGTH)
	else:
		_title = title
	return self

# Adds a component to the modal.
func add_component(component: MessageComponentBuilder) -> InteractionModalAction:
	if _components.size() < MAX_COMPONENTS:
		_components.append(component.build())
	else:
		push_error("Modal components are limited to %d componets" % MAX_COMPONENTS)
	return self

# doc-hide
func get_class() -> String:
	return "InteractionModalAction"

func _get_arguments() -> Array:
	return [
		_interaction_id, _token,
		{
			type = DiscordInteraction.Callback.MODAL,
			data = {
				custom_id = _custom_id,
				title = _title,
				components = _components
			}
		}
	]

func __set(_value) -> void:
	pass
