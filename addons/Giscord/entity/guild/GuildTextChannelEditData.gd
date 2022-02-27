class_name GuildTextChannelEditData extends GuildChannelEditData

func news(value: bool) -> GuildTextChannelEditData:
	_data["type"] = Channel.Type.GUILD_NEWS if value else Channel.Type.GUILD_TEXT
	return self

func set_topic(topic: String) -> GuildTextChannelEditData:
	topic = topic.strip_edges()
	if topic.empty():
		_data["topic"] = null
	else:
		_data["topic"] = topic
	return self

func nsfw(value: bool) -> GuildTextChannelEditData:
	_data["nsfw"] = value
	return self

func set_rate_limit(limit: int) -> GuildTextChannelEditData:
	_data["rate_limit_per_user"] = limit
	return self

func set_perent(channel_id: int) -> GuildTextChannelEditData:
	_data["parent_id"] = str(channel_id)
	return self

func set_archive_duration(duration: int) -> GuildTextChannelEditData:
	_data["default_auto_archive_duration"] = duration
	return self

func get_class() -> String:
	return "GuildTextChannelEditData"
