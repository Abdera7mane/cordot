# Abstract action for guild voice channels.
class_name VoiceChannelAction extends ChannelAction

# Minimum bitrate value.
const MIN_BITRATE: int = 8000

# doc-hide
func _init(rest: DiscordRESTMediator).(rest) -> void:
	pass

# Executes the action.
#
# doc-qualifiers:coroutine
# doc-override-return:BaseGuildVoiceChannel
func submit():
	return _submit()

# Sets the bitrate (in bits) of a voice or stage channel.
func set_bitrate(bitrate: int) -> VoiceChannelAction:
	if bitrate < MIN_BITRATE:
		push_error("Minimum bitrate for a voice channel is %d" % MIN_BITRATE)
	else:
		_data["bitrate"] = bitrate
	return self

# Sets the user limit in the channel.
func user_limit(limit: int) -> VoiceChannelAction:
	_data["user_limit"] = limit
	return self

# Sets the voice RTC region.
func set_rtc_region(region: String) -> VoiceChannelAction:
	_data["rtc_region"] = region
	return self

# Sets the camera video quality mode.
# Check `VoiceChannel.VideoQualityModes`.
func set_video_quality(mode: int) -> VoiceChannelAction:
	_data["video_quality_mode"] = mode
	return self

# Whether the channel should be a stage voice channel.
func as_stage(value: bool) -> VoiceChannelAction:
	_data["type"] = Channel.Type.GUILD_STAGE_VOICE if value else Channel.Type.GUILD_VOICE
	return self

