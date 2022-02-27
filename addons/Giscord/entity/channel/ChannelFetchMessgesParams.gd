class_name ChannelFetchMessgesParams

# warning-ignore-all:return_value_discarded

var _data: Dictionary setget __set, to_dict

func around(message_id: int) -> ChannelFetchMessgesParams:
	if not (has("before") or has("after")):
		_data["around"] = str(message_id)
	else:
		_warn_parms_excluvity()
	return self

func before(message_id: int) -> ChannelFetchMessgesParams:
	if not (has("around") or has("after")):
		_data["before"] = str(message_id)
	else:
		_warn_parms_excluvity()
	return self

func after(message_id: int) -> ChannelFetchMessgesParams:
	if not (has("around") or has("before")):
		_data["after"] = str(message_id)
	else:
		_warn_parms_excluvity()
	return self

func limit(limit: int) -> ChannelFetchMessgesParams:
	if limit < 1 or limit > 100:
		push_error("Messages fetch 'limit' must be in range of 1 to 100")
	else:
		_data["limit"] = limit
	return self

func has(key: String) -> bool:
	return _data.has(key)

func to_dict() -> Dictionary:
	return _data.duplicate()

func get_class() -> String:
	return "ChannelFetchMessgesParams"

func __set(_value) -> void:
	pass

func _warn_parms_excluvity() -> void:
		push_warning(
			"The before, after, and around paramters are mutually exclusive, "
			+ "only one may be passed at a time."
		)
