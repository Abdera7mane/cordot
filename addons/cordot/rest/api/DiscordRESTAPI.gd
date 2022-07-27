class_name DiscordRESTAPI

var token: String
var requester: DiscordRESTRequester
var rest_headers: Dictionary
var entity_manager: BaseDiscordEntityManager

func _init(_token: String, _requester: DiscordRESTRequester, _entity_manager: BaseDiscordEntityManager) -> void:
	token = _token
	requester = _requester
	entity_manager = _entity_manager

	rest_headers = {
		HTTPHeaders.AUTHORIZATION: "Bot %s" % token,
		HTTPHeaders.USER_AGENT: "%s (%s, %s)" % [
			Discord.LIBRARY,
			Discord.LIBRARY_URL,
			Discord.LIBRARY_VERSION
		]
	}

func rest_request(endpoint: String) -> RestRequest:
	return RestRequest.new().url(
			rest_url(endpoint)
		).headers(rest_headers.duplicate(true))

func __set(_value) -> void:
	pass

static func rest_url(endpoint: String) -> String:
	return Discord.REST_URL % Discord.REST_VERSION + endpoint

static func cdn_url(endpoint: String) -> String:
	return Discord.CDN_URL + endpoint
