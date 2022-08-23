# Represents an application on Discord.
class_name DiscordApplication extends DiscordEntity

# Application public flags.
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

# The name of the application.
var name: String                 setget __set

# The icon hash of the application.
var icon_hash: String            setget __set

# The description of the application.
var description: String          setget __set

# Array of rpc origin urls, if rpc is enabled.
var rpc_origins: PoolStringArray setget __set

# When `false` only application owner can join the application's bot to guilds.
var is_bot_public: bool          setget __set

# When `true` the application's bot will only join upon completion of the full
# oauth2 code grant flow.
var bot_require_code_grant: bool setget __set

# The url of the application's terms of service.
var tos_url: String              setget __set

# The url of the application's privacy policy.
var privacy_policy_url: String   setget __set

# User owner id of the application.
var owner_id: int                setget __set

# User object containing info on the owner of the application. Can be partial.
var owner: User                  setget __set, get_owner

# doc-deprecated
var summary: String              setget __set

# Hex encoded verification key.
var verify_key: String           setget __set

# The team this application belongs to, if it is owned by a team.
var team: DiscordTeam            setget __set

# If this application is a game sold on Discord, this field will be the guild to
# which it has been linked.
var guild_id: int                setget __set

# If this application is a game sold on Discord, this field will be the id of
# the "Game SKU" that is created, if exists.
var primary_sku_id: int          setget __set

# If this application is a game sold on Discord, this field will be the URL slug
# that links to the store page.
var slug: String                 setget __set

# The application's default rich presence invite cover image hash.
var cover_image_hash: String     setget __set

# The application's public flags.
var flags: BitFlag               setget __set

# doc-hide
func _init(data: Dictionary).(data["id"]) -> void:
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

# doc-hide
func is_partial() -> bool:
	return not name.empty()

# `owner` getter.
func get_owner() -> User:
	return get_container().users.get(owner_id)

# doc-hide
func get_class() -> String:
	return "DiscordApplication"

func __set(_value) -> void:
	pass
