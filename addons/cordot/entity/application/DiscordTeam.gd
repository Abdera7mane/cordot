class_name DiscordTeam extends DiscordEntity

var _members: Dictionary

var icon_hash: String
var members: Array
var name: String
var owner_id: int
var owner: TeamMember

func _init(data: Dictionary) -> void:
	super(data.id)
	icon_hash = data.get("icon_hash", "")
	_members = data["members"]
	name = data["name"]
	owner_id = data["owner_id"]

func get_members() -> Array:
	return _members.values()

func get_owner() -> TeamMember:
	return _members.get(owner_id)

func get_class() -> String:
	return "DiscordTeam"

func __set(_value) -> void:
	pass

class TeamMember extends DiscordEntity:
	enum MembershipState {
		INVITED  = 1,
		ACCEPTED = 2
	}

	var membership_state: int
	var permissions: PackedStringArray
	var team_id: int
	var user_id: int
	var user: User:
		get = get_user

	func _init(data: Dictionary) -> void:
		super(data.id)
		membership_state = data["membership_state"]
		permissions = data["permissions"]
		team_id = data["team_id"]
		user_id = data["user_id"]

	func get_user() -> User:
		return get_container().users.get(user)

	func get_class() -> String:
		return "DiscordTeam.TeamMember"

	func __set(_value) -> void:
		pass
