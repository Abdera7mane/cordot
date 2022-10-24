# The facade of the Discord API, used to login to bot accounts.
class_name DiscordClient extends Node

# warning-ignore-all:unused_signal
# warning-ignore-all:return_value_discarded

enum {
	# Generic webscoket error.
	ERR_WEBSOCKET = 49
}

# Emitted when the client connect to Discord's gateway websocket server.
# To know if the bot is ready refer to `client_ready` signal
signal connected()

# Emitted when the client reconnects to Discord's gateway websocket server.
# The client may attempt to reconnect when it looses connection to the server
# or when Discord requests a reconnection.
signal reconnected()

# Emitted when the client resumed the session after reconecting (check `reconnected` signal).
signal resumed()

# Emitted when the client fails to connect.
#
# - `int error`: Error code.
signal connection_error(error)

# Emitted when the client disconnects from Discord's gateway websocket server.
signal disconnected()

# Emitted when the client receives a Discord event dispatch and before it gets
# processed internally.
# <https://discord.com/developers/docs/topics/gateway#commands-and-events-gateway-events>
#
# - `String event`: Event name.
# - `Dictionary payload`: Event data.
signal raw_event(event, payload)

# Emitted when the client is connected and ready to interact with Discord API
#
# - `User user`: The connected bot's `User` object.
signal client_ready(user)

# Emitted when a guild channel is created.
#
# - `Guild guild`: The guild in which the channel was created.
# - `Channel channel`: The created channel.
signal channel_created(guild, channel)

# Emitted when a guild channel is updated.
#
# - `Guild guild`: The guild in which the channel was updated.
# - `Channel old`: A copy of the channel before the update.
# - `Channel new`: The updated channel.
signal channel_updated(guild, old, new)

# Emitted when a guild channel is deleted.
#
# - `Guild guild`: The guild in which the channel was deleted.
# - `Channel channel`: The deleted channel.
signal channel_deleted(guild, channel)

# Emitted when a message is pinned or unpinned in a text channel.
#
# - `TextChannel channel`: The channel in which the pins were updated.
# - `int last_pin`: unix time (in seconds) of the last recent pin.
signal channel_pins_updated(channel, last_pin)

# Emitted when a thread is created.
#
# - `Guild guild`: The guild in which the thread was created.
# - `Guild.ThreadChannel thread`: The created thread.
signal thread_created(guild, thread)

# Emitted when a thread is updated.
#
# - `Guild guild`: The guild in which the thread was updated.
# - `Guild.ThreadChannel thread`: The updated thread.
signal thread_updated(guild, old, new)

# Emitted when a thread is updated.
#
# - `Guild guild`: The guild in which the thread was deleted.
# - `Guild.ThreadChannel thread`: The deleted thread.
signal thread_deleted(guild, thread)

# Not implemented
signal thread_list_sync()

# Not implemented
signal thread_member_updated()

# Not implemented
signal thread_members_updated(thread)

# Emitted when a thread is updated.
#
# - `Guild guild`: The guild in which the thread was deleted.
# - `Guild.ThreadChannel thread`: The deleted thread.

# Emitted when a user starts typing in a channel
#
# - `TextChannel channel`: The channel in which the thread was deleted.
# - `User user`: The user who started typing.
# - `int timestamp`: The unix time (in seconds) of when the user started typing.
signal typing_started(channel, user, timestamp)

# Emitted when a guild becomes available again to the client.
#
# - `Guild guild`: The guild object.
signal guild_available(guild)

# Emitted when a guild becomes unavailable due to an outage.
#
# - `Guild guild`: The guild object.
signal guild_unavailable(guild)

# Emitted when the current user joins a new Guild.
#
# - `Guild guild`: The joined guild.
signal guild_created(guild)

# Emitted when a guild is updated.
#
# - `Guild old`: A copy of the guild before the update.
# - `Guild new`: The updated guild.
signal guild_updated(old, new)

# Emitted when the user leaves or is removed from a guild.
#
# - `Guild guild`: The deleted guild.
signal guild_deleted(guild)

# Emitted when a user is banned from a guild.
#
# - `Guild guild`: The guild in which the user was banned.
# - `User user`: The banned user.
signal guild_ban_added(guild, user)

# Emitted when a user is unbanned from a guild.
#
# - `Guild guild`: The guild in which the user was unbanned.
# - `User user`: The unbanned user.
signal guild_ban_removed(guild, user)

# Emitted when a guild's emojis have been updated.
#
# - `Guild guild`: The guild in which the emojis have been updated.
# - `Array emojis`: List of `Emoji` objects.
signal guild_emojis_updated(guild, emojis)

# Emitted when a guild role is created.
#
# - `Guild guild`: The guild in which the role was created.
# - `Guild.Role role`: The created role.
signal guild_role_created(guild, role)

# Emitted when a guild role is updated.
#
# - `Guild guild`: The guild in which the role was updated.
# - `Guild.Role old`: A copy of the role before the update.
# - `Guild.Role new`: The updated role.
signal guild_role_updated(guild, old, new)

# Emitted when a guild role is deleted.
#
# - `Guild guild`: The guild in which the role was deleted.
# - `Guild.Role role`: The deleted role.
signal guild_role_deleted(guild, role)

# Not implemented
signal guild_integrations_updated(guild, integration)

# Not implemented
signal integration_created(integration)

# Not implemented
signal integration_updated(old, new)

# Not implemented
signal integration_deleted(integration)

# Not implemented
signal interaction_created(interaction)

# Not implemented
signal invite_created(invite)

# Not implemented
signal invite_deleted(invite)

# Emitted when a new user joins a guild.
#
# - `Guild guild`: The guild which the user joined.
# - `Guild.Member member`: The user who joined the guild.
signal member_joined(guild, member)

# Emitted when a user is removed from a guild (leave/kick/ban).
#
# - `Guild guild`: The guild in which the user was removed.
# - `User user`: The the removed user.
signal member_left(guild, user)

# Emitted when a guild member is updated and the member is found in the internal cache.
#
# - `Guild guild`: The guild in which the member was updated.
# - `Guild.Member old`: A copy of the member before the update.
# - `Guild.Member new`: The updated member.
signal member_updated(guild, old, new)

# Emitted when a message is created.
#
# - `Message message`: The created message.
signal message_sent(message)

# Emitted when a message is updated and found in the internal cache
#
# - `Message old`: A copy of the message before the update.
# - `Message new`: The updated message.
signal message_updated(old, new)

# Emitted when a message is updated.
#
# - `Message old`: A copy of the message before the update.
# - `Message new`: The updated message.
signal message_deleted(message)

# Emitted when multiple messages are deleted at once.
# and at least one of the messages were found in the internal cache
#
# - `Array messages`: List of `Message` objects of the deleted messages.
# - `TextChannel channel`: The channel in which the messages were deleted.
signal message_bulk_deleted(messages, channel)

# Emitted when a user's presence or info, such as name or avatar, is updated.
#
# - `Presence presence`: The presence object.
signal presence_updated(presence)

# Not implemented
signal stage_instance_created(channel, instance)

# Not implemented
signal stage_instance_deleted(channel, instance)

# Not implemented
signal stage_instance_updated(channel, old, new)

# Not implemented
signal user_updated(old, new)

# Emitted when a user adds a reaction to a message and found in the internal cache.
#
# - `Message message`: The message in which the reaction was added.
# - `User user`: The user who reacted to the message.
# - `MessageReaction reaction`: The added reaction.
signal reaction_added(message, user, reaction)

# Emitted when a user removes a reaction from a message and found in the internal cache.
#
# - `Message message`: The message in which the reaction was removed.
# - `User user`: The user who removed the reaction from the message.
# - `MessageReaction reaction`: The removed reaction.
signal reaction_removed(message, user, reaction)

# Emitted when a user explicitly removes all reactions from a message.
#
# - `Message message`: The message in which the reactions were removed.
# - `Array reaction`: List of `MessageReaction` objects of the removed reactions.
signal reactions_cleared(message, reactions)

# Emitted when a bot removes all instances of a given emoji from the reactions of a message.
#
# - `Message message`: The message in which the reactions were removed.
# - `Array reaction`: List of `MessageReaction` objects of the removed reactions.
signal reactions_cleared_emoji(message, reaction)

# Emitted when someone joins/leaves/moves voice channels.
#
# - `Guild.VoiceState previous`: The previous voice state of the user.
# - `Guild.VoiceState current`: The current voice state of the user.
signal voice_state_updated(previous, current)

# Not implemented
signal voice_server_updated(old, new)

# Not implemented
signal webhooks_updated(old, new)

var _connection_state: ConnectionState         setget __set

# The entity manager instance associated this client.
var entity_manager: BaseDiscordEntityManager   setget __set

# The REST client instance associated this client.
var rest: DiscordRESTAdapter                   setget __set

# The REST client instance associated this client.
var gateway_websocket: DiscordWebSocketAdapter setget __set

# Unused, might be removed in the future.
var voice_websocket: VoiceWebSocketAdapter     setget __set

# A dictionary holding registered application/text commands.
# Should not be modified directly.
var commands_map: Dictionary setget __set

# If `true`, the REST client will use an HTTP connection pool to send requests.
# Must be set before calling `login()`. This is an **unstable experimental** feature,
# it is highly recommended to leave it off, might be removed in the future.
var use_http_pool: bool

# Constructs a new DiscordClient with a bot `token`.
# The`intents` parameter is used to specify the group of events to be notified about.
func _init(token: String, intents: int = GatewayIntents.UNPRIVILEGED) -> void:
	name = "DiscordClient"
	pause_mode = PAUSE_MODE_PROCESS
	
	_connection_state = ConnectionState.new(token, intents)

# Connects to Discord's gateway and identify as a bot account.
# The node has to be inside a SceneTree or the method will fail.
func login() -> void:
	if not is_inside_tree():
		push_error("Not inside a scene tree !")
		emit_signal("connection_error", ERR_UNCONFIGURED)
		return
	_setup()
	gateway_websocket.connect_to_gateway()

# Disconnects from Discord's gateway if already connected.
func logout() -> void:
	gateway_websocket.auto_reconnect = false
	gateway_websocket.disconnect_from_gateway()

func update_presence(presence: PresenceUpdate) -> void:
	gateway_websocket.send_packet(Packet.new({
		op = GatewayOpcodes.Gateway.PRESENCE_UPDATE,
		d = presence.to_dict()
	}))

# Whether this client instance is in an active connection
func is_client_connected() -> bool:
	return gateway_websocket.is_connected_to_gateway()

# Gets the associated token.
func get_token() -> String:
	return self._connection_state.token

# Gets the associated intents flags.
func get_intents() -> int:
	return self._connection_state.intents

# Gets the gateway server latency in milliseconds.
func get_ping() -> int:
	return self.gateway_websocket.latency

# Gets the client uptime in milliseconds.
func get_uptime_ms() -> int:
	return self._connection_state.get_uptime_ms()

# Gets the user object of the current connected bot account.
func get_self() -> User:
	return self.entity_manager.get_self()

# Gets a user by `id`.
func get_user(id: int) -> User:
	return self.entity_manager.get_user(id)

# Gets a user's presence by `id`.
func get_presence(id: int) -> Presence:
	return self.entity_manager.get_presence(id)

# Gets a guild by `id`.
func get_guild(id: int) -> Guild:
	return self.entity_manager.get_guild(id)

# Gets a channel by `id`.
func get_channel(id: int) -> Channel:
	return self.entity_manager.get_channel(id)

# Gets an application by `id`.
func get_application(id: int) -> DiscordApplication:
	return self.entity_manager.get_application(id)

# Gets a the application object of the current bot account.
func get_client_application() -> DiscordApplication:
	return get_application(entity_manager.container.application_id)

# Gets a Discord team object by `id`.
func get_team(id: int) -> DiscordTeam:
	return self.entity_manager.get_team(id)

# Registers an applications command executor for `command` name.
func register_application_command_executor(
	command: String, executor: ApplicationCommandExecutor
) -> void:
	commands_map[command] = executor

# Registers an application command with the help of a command `builder` object
# If a `guild_id` is provided the command will only be registered on that guild,
# otherwise the command will be registered globally. The method should be called
# one time only in the whole bot life cycle, calling this with an already
# registered command will override its configuration.
#
# doc-qualifiers:coroutine
# doc-override-return:DiscordApplicationCommand
func register_application_command(
	builder: ApplicationCommandBuilder, guild_id: int = 0
) -> DiscordApplicationCommand:
	if not is_client_connected():
		push_error("Discord client must be connected in order to register  application commands")
		return yield(get_tree(), "idle_frame")
	
	var application_id: int = get_client_application().id
	if guild_id:
		return rest.application.create_guild_application_command(
			application_id,
			guild_id,
			builder.build()
		)
	
	return rest.application.create_global_application_command(
		application_id,
		builder.build()
	)

# doc-hide
func get_class() -> String:
	return "DiscordClient"

func _create_gateway_websocket(_entity_manager: BaseDiscordEntityManager) -> DiscordWebSocketAdapter:
	var adapter: DiscordWebSocketAdapter = DiscordWebSocketAdapter.new(_connection_state)
	
	adapter.connect("connected", self, "_on_connected")
	adapter.connect("reconnected", self, "_on_reconnected")
	adapter.connect("connection_error", self, "_on_connection_error")
	adapter.connect("invalid_session", self, "_on_invalid_session")
	adapter.connect("disconnected", self, "_on_disconnected")
	adapter.connect("packet_received", self, "_on_packet")

	var handlers: Array = [
		ChannelPacketsHandler.new(_entity_manager),
		GuildPacketsHandler.new(_entity_manager),
		MessagePacketsHandler.new(_entity_manager),
		ThreadPacketsHandler.new(_entity_manager),
		IntegrationPacketshandler.new(_entity_manager),
		ReadyPacketHandler.new(_connection_state, _entity_manager),
		InteractionPacketsHandler.new(_entity_manager)
	]
	
	for handler in handlers:
		adapter.add_handler(handler)
		handler.connect("transmit_event", self, "_transmit_event")
	
	return adapter

func _create_voice_websocket() -> VoiceWebSocketAdapter:
	var adapter: VoiceWebSocketAdapter = VoiceWebSocketAdapter.new()
	return adapter


func _setup() -> void:
	entity_manager = DiscordEntityManager.new()
	var intents_map: Dictionary = GatewayIntents.get_script_constant_map()
	var intents: BitFlag = BitFlag.new(intents_map).put(get_intents())
	entity_manager.cache_flags_from_intents(intents)

	rest = DiscordRESTAdapter.new(_connection_state.token, entity_manager, use_http_pool)
	gateway_websocket = _create_gateway_websocket(entity_manager)
	voice_websocket = _create_voice_websocket()
	
	entity_manager.rest_mediator = rest.mediator
	
	self.add_child(rest)
	self.add_child(gateway_websocket)
	self.add_child(voice_websocket)

func _on_connected() -> void:
	emit_signal("connected")

func _on_connection_error() -> void:
	emit_signal("connection_error", ERR_WEBSOCKET)

func _on_invalid_session(may_resume) -> void:
	if not may_resume:
		entity_manager.reset()

func _on_reconnected() -> void:
	emit_signal("reconnected")

func _on_disconnected() -> void:
	entity_manager.reset()
	emit_signal("disconnected")

func _on_packet(packet: DiscordPacket) -> void:
	if packet.is_gateway_dispatch():
		self.emit_signal("raw_event", packet.get_event_name(), packet.get_data())

func _transmit_event(event: String, arguments: Array) -> void:
	if has_signal(event):
		callv("emit_signal", [event] + arguments)
		if event == "interaction_created":
			_forward_interaction(arguments[0] as DiscordInteraction)
	else:
		assert(false, "Transmitted non-existing event '%s'")

func _forward_interaction(interaction: DiscordInteraction) -> void:
	if interaction.is_command() or interaction.is_autocomplete():
		var command: String = interaction.data.name
		if commands_map.has(command):
			var executor: ApplicationCommandExecutor = commands_map[command]
			executor.interact(interaction)
	else:
		for executor in commands_map.values():
			executor.interact(interaction)

func _to_string() -> String:
	return "[%s:%d]" % [self.get_class(), self.get_instance_id()]

func __set(_value) -> void:
	pass
