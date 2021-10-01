class_name Packets

class IdentifyPacket extends Packet:
	
	func _init(connection_state: ConnectionState) -> void:
		self.payload = {
			"op": GatewayOpcodes.General.IDENTIFY,
			"d": {
				"token": connection_state.token,
				"intents": connection_state.intents,
				"properties": {
					"$os": OS.get_name(),
					"$browser": Discord.LIBRARY,
					"$device": Discord.LIBRARY
				},
				"compress": false,
				"large_threshold": 50,
				"guild_subscriptions": true,
				"shard": [0, 1],
				"presence": {
					"activities": [{
						"name": "Rayssy is a bad boi",
						"type": Activity.Type.GAME
					}],
					"afk": false
				}
			}
		}

class ResumePacket extends Packet:
	
	func _init(connection_state: ConnectionState, sequence: int) -> void:
		self.payload = {
			"op": GatewayOpcodes.General.RESUME,
			"d": {
				"token": connection_state.token,
				"session_id": connection_state.session_id,
				"seq": sequence
			}
		}

class HeartBeatPacket extends Packet:
	
	func _init(sequence: int) -> void:
		self.payload = {
			"op": GatewayOpcodes.General.HEARTBEAT,
			# warning-ignore:incompatible_ternary
			"d": sequence if sequence != 0 else null
		}

class RequestGuildMembersPacket extends Packet:
	var guild_id: int
	var query: String
	var limit: int
	var precences: bool
	var user_ids: Array
	var nonce: String
	
	func _init(data: Dictionary) -> void:
		self.guild_id = data.guild_id
		self.query = data.query
		self.limit = data.limit
		self.precences = data.precences
		self.user_ids = data.user_ids
		self.nonce = data.nonce
	
	func get_payload() -> Dictionary:
		var payload: Dictionary = {
			"op": GatewayOpcodes.General.REQUEST_GUILD_MEMBERS,
			"d": {
				"guild_id": str(self.guild_id),
				"limit": self.limit,
				"presences": self.precences
			}
		}
		if (not nonce.empty()):
			payload["nonce"] = nonce
		if (not query.empty()):
			payload["query"] = query
		elif (not user_ids.empty()):
			var ids_strings = []
			for user_id in self.user_ids:
				ids_strings.append(str(user_id))
			payload["user_ids"] = ids_strings
			
		return payload
