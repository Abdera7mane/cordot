class_name DiscordRESTAdapter extends Node

const AUTH_HEADER: String = "Authorization: Bot %s"
const USER_AGENT_HEADER: String = "User-Agent: %s (%s, %s)" % [Discord.LIBRARY, Discord.LIBRARY_URL, Discord.LIBRARY_VERSION]
const CONTENT_TYPE_HEADER: String = "Content-Type: application/json"

var requester: DiscordRESTRequester setget __set
var mediator: DiscordRESTMediator   setget __set

var channel: ChannelRESTAPI         setget __set
var guild: GuildRESTAPI             setget __set
var user: UserRESTAPI               setget __set
var webhook: WebhookRESTAPI         setget __set

func _init(token: String, entity_manger: BaseDiscordEntityManager) -> void:
	name = "RESTAdapter"
	
	requester = DiscordRESTRequester.new()
	mediator = Mediator.new(self)
	
	channel = ChannelRESTAPI.new(token, requester, entity_manger)
	guild = GuildRESTAPI.new(token, requester, entity_manger)
	user = UserRESTAPI.new(token, requester, entity_manger)
	webhook = WebhookRESTAPI.new(token, requester, entity_manger)

func __set(_value) -> void:
	pass

class Mediator extends DiscordRESTMediator:
	
	var client: WeakRef
	
	func _init(rest_client: DiscordRESTAdapter) -> void:
		client = weakref(rest_client)
	
	func get_rest() -> DiscordRESTAdapter:
		return client.get_ref()
	
	func request_async(type: int, request: String, arguments: Array):
		var rest: DiscordRESTAdapter = get_rest()
		match type:
			DiscordREST.CHANNEL:
				return rest.channel.callv(request, arguments)
			DiscordREST.GUILD:
				return rest.guild.callv(request, arguments)
			DiscordREST.USER:
				return rest.user.callv(request, arguments)
			DiscordREST.WEBHOOK:
				return rest.webhook.callv(request, arguments)

	func cdn_download_async(url: String) -> Resource:
		return get_rest().requester.cdn_download_async(url)
