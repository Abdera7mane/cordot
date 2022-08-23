# Standalone Discord REST API client.
class_name DiscordRESTAdapter extends Node

# REST API requester instance.
var requester: DiscordRESTRequester setget __set

# Mediator of this client.
var mediator: DiscordRESTMediator   setget __set

# Application REST API client.
var application: ApplicationRESTAPI setget __set

# Channel REST API client.
var channel: ChannelRESTAPI         setget __set

# Guild REST API client.
var guild: GuildRESTAPI             setget __set

# Interaction REST API client.
var interaction: InteractionRESTAPI setget __set

# User REST API client.
var user: UserRESTAPI               setget __set

# Webhook REST API client.
var webhook: WebhookRESTAPI         setget __set

# Constructs a new `DiscordRESTAdapter` with a bot `token`. You can optionally
# pass an `entity_manager` for different caching settings. `use_pool` enables
# the use of a HTTP connection pool (experimental unstable feature).
#
# doc-override-param-default:(1;DiscordEntityManager.new())
func _init(token: String, entity_manager := DiscordEntityManager.new(), use_pool: bool = false) -> void:
	name = "RESTAdapter"
	
	requester = DiscordRESTRequester.new(use_pool)
	mediator = Mediator.new(self)
	
	application = ApplicationRESTAPI.new(token, requester, entity_manager)
	channel = ChannelRESTAPI.new(token, requester, entity_manager)
	guild = GuildRESTAPI.new(token, requester, entity_manager)
	interaction = InteractionRESTAPI.new(token, requester, entity_manager)
	user = UserRESTAPI.new(token, requester, entity_manager)
	webhook = WebhookRESTAPI.new(token, requester, entity_manager)

func __set(_value) -> void:
	pass

# doc-hide
class Mediator extends DiscordRESTMediator:
	
	var client: WeakRef
	
	func _init(rest_client: DiscordRESTAdapter) -> void:
		client = weakref(rest_client)
	
	func get_rest() -> DiscordRESTAdapter:
		return client.get_ref()
	
	func request_async(type: int, request: String, arguments: Array):
		var rest: DiscordRESTAdapter = get_rest()
		match type:
			DiscordREST.APPLICATION:
				return rest.application.callv(request, arguments)
			DiscordREST.CHANNEL:
				return rest.channel.callv(request, arguments)
			DiscordREST.GUILD:
				return rest.guild.callv(request, arguments)
			DiscordREST.INTERACTION:
				return rest.interaction.callv(request, arguments)
			DiscordREST.USER:
				return rest.user.callv(request, arguments)
			DiscordREST.WEBHOOK:
				return rest.webhook.callv(request, arguments)
	
	func cdn_download_async(url: String) -> Resource:
		return get_rest().requester.cdn_download_async(url)
