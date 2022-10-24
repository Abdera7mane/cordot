class_name InteractionAutocompleteAction extends DiscordRESTAction

# Maximum number of choices in an autocomplete.
const MAX_CHOICES: int = 25

# Maximum number of characters for string options.
const MAX_CHARACTERS: int = 100

var _interaction_id: int setget __set
var _token: String       setget __set

var _choices: Array      setget __set

# Constructs a new `InteractionAutocompleteAction` instance.
func _init(
	rest: DiscordRESTMediator, interaction_id: int,  token: String
).(rest) -> void:
	_type = DiscordREST.INTERACTION
	_method = "create_response"
	
	_interaction_id = interaction_id
	_token = token

# Adds a string choice.
func add_string_choice(name: String, value: String, localizations := {}) -> InteractionAutocompleteAction:
	return add_choice(name, value, localizations)

# Adds an integer choice.
func add_integer_choice(name: String, value: int, localizations := {}) -> InteractionAutocompleteAction:
	return add_choice(name, value, localizations)

# Adds a number choice.
func add_double_choice(name: String, value: float, localizations := {}) -> InteractionAutocompleteAction:
	return add_choice(name, value, localizations)

# Adds a choice, `value` must be either a `string`, `number` or `flaot`.
func add_choice(name: String, value, localizations := {}) -> InteractionAutocompleteAction:
	if value is String:
		if value.length() > MAX_CHARACTERS:
			push_error("Autocomplete choice is limited to %d characters" % MAX_CHARACTERS)
			return self
	elif not (value is int or value is float):
		push_error("Autocomplete choice can only be a string, integer or double")
		return self
	
	if _choices.size() < MAX_CHOICES:
		_choices.append({
			name = name,
			name_localizations = localizations,
			value = value
		})
	else:
		push_error("Autocomplete choices are limited to %d choices" % MAX_CHOICES)
	return self

func _get_arguments() -> Array:
	var data: Dictionary = {
		type = DiscordInteraction.Callback.AUTOCOMPLETE_RESULT,
		data = {choices = _choices}
	}
	return [_interaction_id, _token, data]

# doc-hide
func get_class() -> String:
	return "InteractionAutocompleteAction"

func __set(_value) -> void:
	pass
