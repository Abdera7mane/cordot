# Mediator class of `DiscordRESTAPIAdapter` class.
class_name DiscordRESTMediator

# warning-ignore-all:unused_argument

# Forwards the request to one of `DiscordRESTAPIAdapter` sub client specified by
# `type. `request` is the request endpoint. `arguments` is the request arguments.
#
# doc-qualifiers:coroutine
func request_async(type: int, request: String, arguments: Array):
	return null

# Downloads the resource at the given `url`.
#
# doc-qualifiers:coroutine
func cdn_download_async(url: String) -> Resource:
	return null
