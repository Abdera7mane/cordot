# doc-hide
class_name Packets

class IdentifyPacket extends Packet:
	
	func _init(context: GatewayContext, shard: int) -> void:
		payload = {
			op = GatewayOpcodes.Gateway.IDENTIFY,
			d = {
				token = context.token,
				intents = context.intents,
				properties = {
					os = OS.get_name(),
					browser = Discord.LIBRARY,
					device = Discord.LIBRARY
				},
				large_threshold = context.large_threshold,
				shard = [shard, context.total_shards]
			}
		}

class ResumePacket extends Packet:
	
	func _init(token: String, session_id: String, sequence: int) -> void:
		self.payload = {
			op = GatewayOpcodes.Gateway.RESUME,
			d = {
				token = token,
				session_id = session_id,
				seq = sequence
			}
		}

class HeartBeatPacket extends Packet:
	
	func _init(sequence: int) -> void:
		self.payload = {
			op = GatewayOpcodes.Gateway.HEARTBEAT,
			# warning-ignore:incompatible_ternary
			d = sequence if sequence != 0 else null
		}

class RequestGuildMembersPacket extends Packet:
	var guild_id: int
	var query: String
	var limit: int
	var precences: bool
	var user_ids: Array
	var nonce: String
	
	func _init(data: Dictionary) -> void:
		self.guild_id = data["guild_id"]
		self.precences = data["precences"]
		self.limit = data["limit"]
		self.query = data.get("query", "")
		self.user_ids = data.get("user_ids", [])
		self.nonce = UUID.v4()
	
	func get_payload() -> Dictionary:
		var payload: Dictionary = {
			op = GatewayOpcodes.Gateway.REQUEST_GUILD_MEMBERS,
			d = {
				guild_id =  str(self.guild_id),
				limit = self.limit,
				presences = self.precences
			}
		}
		if not nonce.empty():
			payload["nonce"] = nonce
		if not query.empty():
			payload["query"] = query
		elif not user_ids.empty():
			var ids_strings = []
			for user_id in self.user_ids:
				ids_strings.append(str(user_id))
			payload["user_ids"] = ids_strings
			
		return payload
