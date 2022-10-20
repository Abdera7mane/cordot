# Abstract text channel action.
class_name TextChannelAction extends ChannelAction

# Maximum channel topic length.
const MAX_TOPIC_LENGTH: int = 1024

# Maximum rate limit wait time in seconds.
const MAX_RATE_LIMIT: int = 21600

# doc-hide
func _init(rest: DiscordRESTMediator).(rest) -> void:
	pass

# Executes the action.
#
# doc-qualifiers:coroutine
# doc-override-return:GuildTextChannel
func submit():
	return _submit()

# Sets the channel topic.
func set_topic(topic: String) -> TextChannelAction:
	if topic.length() > MAX_TOPIC_LENGTH:
		push_error("Channel topic length is limited to %d characters" % MAX_TOPIC_LENGTH)
	else:
		_data["topic"] = topic
	return self

# Sets the message cooldown time in seconds.
func set_rate_limit(limit: int) -> TextChannelAction:
	if limit < 0 or limit > MAX_RATE_LIMIT:
		push_error("Channel rate limit must be in range of 0 to %d seconds" % MAX_RATE_LIMIT)
	else:
		_data["rate_limit_per_user"] = limit
	return self

# Sets the parent of the channel.
# `id` must point to a category channel.
func set_parent(id: int) -> TextChannelAction:
	_data["parent_id"] = str(id)
	return self

# Sets the default thread archive duration,
# applied to newly created thread.
func set_auto_archive_duration(duration: int) -> TextChannelAction:
	_data["default_auto_archive_duration"] = duration
	return self

# Whether the channel should be a news channel.
func as_news(value: bool) -> TextChannelAction:
	_data["type"] = Channel.Type.GUILD_NEWS if value else Channel.Type.GUILD_TEXT
	return self

