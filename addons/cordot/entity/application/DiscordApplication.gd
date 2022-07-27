class_name DiscordApplication extends DiscordEntity

enum Flags {
	GATEWAY_PRESENCE                 = 1 << 12,
	GATEWAY_PRESENCE_LIMITED         = 1 << 13,
	GATEWAY_GUILD_MEMBERS            = 1 << 14,
	GATEWAY_GUILD_MEMBERS_LIMITED    = 1 << 15,
	VERIFICATION_PENDING_GUILD_LIMIT = 1 << 16,
	EMBEDDED                         = 1 << 17,
	GATEWAY_MESSAGE_CONTENT          = 1 << 18,
	GATEWAY_MESSAGE_CONTENT_LIMITED  = 1 << 19
}

var name: String
var icon_hash: String
var description: String
var rpc_origins: PackedStringArray
var is_bot_public: bool
var bot_require_code_grant: bool
var tos_url: String
var privacy_policy_url: String
var owner_id: int
var owner: User
var summary: String
var verify_key: String
var team: DiscordTeam
var guild_id: int
var primary_sku_id: int
var slug: String
var cover_image_hash: String
var flags: BitFlag

func _init(data: Dictionary) -> void:
	super(data["id"])
	flags = BitFlag.new(Flags)

	name = data["name"]
	description = data.get("description", "")
	icon_hash = data.get("icon_hash", "")
	rpc_origins = data.get("rpc_origins", [])
	is_bot_public = data.get("is_bot_public", false)
	bot_require_code_grant = data.get("bot_require_code_grant", false)
	tos_url = data.get("tos_url", "")
	privacy_policy_url = data.get("privacy_policy_url", "")
	owner_id = data.get("owner_id", 0)
	summary = data.get("summary", "")
	verify_key = data.get("verify_key", "")
	team = data.get("team")
	guild_id = data.get("guild_id", 0)
	primary_sku_id = data.get("primary_sku_id", 0)
	slug = data.get("slug", "")
	cover_image_hash = data.get("cover_image_hash", "")
	flags.flags = data.get("flags", 0)

func is_partial() -> bool:
	return not name.is_empty()

func get_owner() -> User:
	return get_container().users.get(owner_id)

func get_class() -> String:
	return "DiscordApplication"

func __set(_value) -> void:
	pass
