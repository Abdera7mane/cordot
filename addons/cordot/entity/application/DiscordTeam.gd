class_name DiscordTeam extends DiscordEntity

var _members: Dictionary setget __set

var icon_hash: String    setget __set
var members: Array       setget __set, get_members
var name: String         setget __set
var owner_id: int        setget __set
var owner: TeamMember    setget __set, get_owner

func _init(data: Dictionary).(data["id"]) -> void:
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
	
	var membership_state: int        setget __set
	var permissions: PoolStringArray setget __set
	var team_id: int                 setget __set
	var user_id: int                 setget __set
	var user: User                   setget __set, get_user
	
	func _init(data: Dictionary).(data["id"]) -> void:
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
