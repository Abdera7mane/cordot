class_name GuildVoiceChannelEditData extends GuildChannelEditData

func set_bitrate(bitrate: int) -> GuildVoiceChannelEditData:
	_data["bitrate"] = bitrate
	return self

func set_user_limit(limit: int) -> GuildVoiceChannelEditData:
	_data["user_limit"] = limit
	return self

func set_perent(channel_id: int) -> GuildVoiceChannelEditData:
	_data["parent_id"] = str(channel_id)
	return self

func set_rtc_region(region: String) -> GuildVoiceChannelEditData:
	_data["rtc_region"] = region
	return self

func auto_select_rtc_region() -> GuildVoiceChannelEditData:
	_data["rtc_region"] = null
	return self

func set_video_quality_mode(mode: int) -> GuildVoiceChannelEditData:
	_data["video_quality_mode"] = mode
	return self

func get_class() -> String:
	return "GuildVoiceChannelEditData"
