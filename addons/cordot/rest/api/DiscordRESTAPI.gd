# Abstract class for Discord REST API sub-clients.
class_name DiscordRESTAPI

# The bot token.
var token: String                            setget __set

# REST Requester reference.
var requester: DiscordRESTRequester          setget __set

# Base HTTP headers passed on every request.
var rest_headers: Dictionary                 setget __set

# The entity_manager for constructing and caching Discord entities.
var entity_manager: BaseDiscordEntityManager setget __set

# `DiscordRESTPI` constructor.
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

# Creates a `RestRequest` object for `endpoint` and pass the default headers.
func rest_request(endpoint: String, reason: String = "") -> RestRequest:
	var request: RestRequest = RestRequest.new().url(
		rest_url(endpoint)
	).headers(rest_headers.duplicate(true))
	reason = reason.strip_edges()
	if not reason.empty():
		# warning-ignore:return_value_discarded
		request.set_header("X-Audit-Log-Reason", reason)
	return request

func __set(_value) -> void:
	pass

# Returns the REST URL for the given `endpoint`.
static func rest_url(endpoint: String) -> String:
	return Discord.REST_URL % Discord.REST_VERSION + endpoint

# Returns the CDN URL for the given `endpoint`.
static func cdn_url(endpoint: String) -> String:
	return Discord.CDN_URL + endpoint
