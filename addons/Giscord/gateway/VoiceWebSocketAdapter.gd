class_name VoiceWebSocketAdapter extends BaseWebSocketAdapter

const DISCORD_VOICE_GATEWAY_VERSION: int = 4

func _init() -> void:
	self.name = "VoiceWebsocketAdapter"

func get_class() -> String:
	return "VoiceWebSocketAdapter"
