class_name User extends MentionableEntity

enum Flags {
	NONE,
	DISCORD_EMPLOYEE             = 1 << 0,
	PARTNERED_SERVER_OWNER       = 1 << 1,
	HYPESQUAD_EVENTS             = 1 << 2,
	BUG_HUNTER_LEVEL1            = 1 << 3,
	HOUSE_BRAVERY                = 1 << 6,
	HOUSE_BRILLIANCE             = 1 << 7,
	HOUSE_BALANCE                = 1 << 8,
	EARLY_SUPPORTER              = 1 << 9,
	TEAM_USER                    = 1 << 10,
	SYSTEM                       = 1 << 12,
	BUG_HUNTER_LEVEL2            = 1 << 14,
	VERIFIED_BOT                 = 1 << 16,
	EARLY_VERIFIED_BOT_DEVELOPER = 1 << 17
}

enum PremiumType {
	NONE,
	NITRO_CLASSIC,
	NITRO
}

var username: String    setget __set
var discriminator: int  setget __set
var avatar_hash: String setget __set
var email: String       setget __set
var locale: String      setget __set
var is_bot: bool        setget __set
var is_system: bool     setget __set
var mfa_enabled: bool   setget __set
var banner_hash: String setget __set
var accent_color: Color setget __set
var verified: bool      setget __set
var premium_type: int   setget __set
var flags: int          setget __set
var public_flags: int   setget __set

func _init(data: Dictionary).(data["id"]) -> void:
	_update(data)

func get_tag() -> String:
	return "%s#%04d" % [self.username, self.discriminator]

func get_mention() -> String:
	return "<@%d>" % self.get_id()

func get_nickname_mention() -> String:
	return "<@!%d>" % self.get_id()

func join_date_timestamp() -> int:
	return self.snowflake.get_timestamp()

func get_class() -> String:
	return "User"

func _update(data: Dictionary) -> void:
	username = data.get("username", username)
	discriminator = data.get("discriminator", discriminator)
	avatar_hash = data.get("avatar_hash", avatar_hash)
	email = data.get("email", email)
	locale = data.get("locale", locale)
	is_bot = data.get("is_bot", is_bot)
	is_system = data.get("is_system", is_system)
	mfa_enabled = data.get("mfa_enabled", mfa_enabled)
	verified = data.get("verified", verified)
	banner_hash = data.get("banner_hash", banner_hash)
	accent_color = data.get("accent_color", accent_color)
	premium_type = data.get("premium_type", premium_type)
	flags = data.get("flags", flags)
	public_flags = data.get("public_flags", public_flags)

func __set(_value) -> void:
	.__set(_value)
