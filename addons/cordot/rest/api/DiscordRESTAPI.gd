class_name DiscordRESTAPI

var token: String                            setget __set
var requester: DiscordRESTRequester          setget __set
var rest_headers: PoolStringArray            setget __set
var entity_manager: BaseDiscordEntityManager setget __set

func _init(_token: String, _requester: DiscordRESTRequester, _entity_manager: BaseDiscordEntityManager) -> void:
	token = _token
	requester = _requester
	entity_manager = _entity_manager
		
	rest_headers = [
		HTTPHeaders.AUTHORIZATION.format({token = token}),
		HTTPHeaders.USER_AGENT.format({
			name = Discord.LIBRARY,
			url = Discord.LIBRARY_URL,
			version = Discord.LIBRARY_VERSION
		}),
	]

func rest_request(endpoint: String) -> RestRequest:
	return RestRequest.new().url(rest_url(endpoint)).headers(rest_headers)

func __set(_value) -> void:
	pass

static func rest_url(endpoint: String) -> String:
	return Discord.REST_URL % Discord.REST_VERSION + endpoint

static func cdn_url(endpoint: String) -> String:
	return Discord.CDN_URL + endpoint
