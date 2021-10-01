class_name DiscordTeam extends DiscordEntity

var _members: Dictionary setget __set

var icon_hash: String    setget __set
var members: Array       setget __set
var name: String         setget __set
var owner_id: int        setget __set
var owner: Member        setget __set

func get_class() -> String:
	return "Team"

func __set(_value) -> void:
	pass

class Member extends DiscordEntity:
	enum State {
		INVITED  = 1,
		ACCEPTED = 2
	}
	
	var membership_state: int        setget __set
	var permissions: PoolStringArray setget __set
	var team_id: int                 setget __set
	var user_id: int                 setget __set
	var user: User                   setget __set
	
	func get_class() -> String:
		return "Team.Member"
		
	func __set(_value) -> void:
		pass
