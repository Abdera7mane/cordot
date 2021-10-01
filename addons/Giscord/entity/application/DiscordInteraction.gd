class_name DiscordInteraction extends DiscordEntity

enum Type {
	PING                = 1,
	APPLICATION_COMMAND = 2,
	MESSAGE_COMPONENT   = 3
}

var type: int    setget __set
var name: String setget __set
var user_id: int setget __set
var user: User   setget __set, get_user

func _init(data: Dictionary).(data.id) -> void:
	type = data.type
	name = data.name
	user = data.user_id

func get_user() -> User:
	return self.get_container().users.get(self.user_id)

func __set(_value) -> void:
	pass
