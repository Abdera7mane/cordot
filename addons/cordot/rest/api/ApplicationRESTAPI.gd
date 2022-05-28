class_name ApplicationRESTAPI extends DiscordRESTAPI

func _init(_token: String,
	_requester: DiscordRESTRequester,
	_entity_manager: BaseDiscordEntityManager
).(_token, _requester, _entity_manager) -> void:
	pass

func get_global_application_commands(application_id: int) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMANDS.format({application_id = application_id})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_commands_response(response)

func create_global_application_command(application_id: int, params: Dictionary) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMANDS.format({application_id = application_id})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)

func get_global_application_command(application_id: int, command_id: int) -> DiscordApplicationCommand:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMAND.format({
			application_id = application_id,
			command_id = command_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)

func edit_global_application_command(application_id: int, command_id: int, params: Dictionary) -> DiscordApplicationCommand:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMAND.format({
			application_id = application_id,
			command_id = command_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)


func delete_global_application_command(application_id: int, command_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMAND.format({
			application_id = application_id,
			command_id = command_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func bulk_overwrite_global_application_commands(application_id, params: Array) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.APPLICATION_COMMANDS.format({application_id = application_id})
	).json_body(params).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_commands_response(response)

func get_guild_application_commands(application_id: int, guild_id: int) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMANDS.format({
			application_id = application_id,
			guild_id = guild_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_commands_response(response)

func create_guild_application_command(application_id: int, guild_id: int, params: Dictionary) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMANDS.format({
			application_id = application_id,
			guild_id = guild_id
		})
	).json_body(params).method_post()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)

func get_guild_application_command(application_id: int, guild_id: int, command_id: int) -> DiscordApplicationCommand:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMAND.format({
			application_id = application_id,
			guild_id = guild_id,
			command_id = command_id
		})
	).method_get()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)

func edit_guild_application_command(application_id: int, guild_id: int, command_id: int, params: Dictionary) -> DiscordApplicationCommand:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMAND.format({
			application_id = application_id,
			guild_id = guild_id,
			command_id = command_id
		})
	).json_body(params).method_patch()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_command_response(response)

func delete_guild_application_command(application_id: int, guild_id: int, command_id: int) -> bool:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMAND.format({
			application_id = application_id,
			guild_id = guild_id,
			command_id = command_id
		})
	).method_delete()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return response.code == HTTPClient.RESPONSE_NO_CONTENT

func bulk_overwrite_guild_application_commands(application_id, guild_id: int, params: Array) -> Array:
	var request: RestRequest = rest_request(
		DiscordREST.ENDPOINTS.GUILD_APPLICATION_COMMANDS.format({
			application_id = application_id,
			guild_id = guild_id
		})
	).json_body(params).method_put()
	var response: HTTPResponse = yield(requester.request_async(request), "completed")
	return _handle_application_commands_response(response)

func get_guild_application_command_permissions(_application_id, _guild_id: int) -> Array:
	return []

func get_application_command_permissions(_application_id, _guild_id: int, _command_id: int) -> Object:
	return null

func edit_application_command_permissions(_application_id, _guild_id: int, _command_id: int, _params: Dictionary) -> Object:
	return null

func batch_edit_application_command_permissions(_application_id, _guild_id: int, _command_id: int, _params: Array) -> Array:
	return []

func _handle_application_commands_response(response: HTTPResponse) -> Array:
	var commands: Array = []
	if response.successful():
		var commands_data: Array = parse_json(response.body.get_string_from_utf8())
		for command_data in commands_data:
			var command := entity_manager.application_manager.construct_application_command(command_data)
			commands.append(command)
	return commands

func _handle_application_command_response(response: HTTPResponse) -> DiscordApplicationCommand:
	var command: DiscordApplicationCommand = null
	if response.successful():
		var command_data: Dictionary = parse_json(response.body.get_string_from_utf8())
		command = entity_manager.application_manager.construct_application_command(command_data)
	return command
