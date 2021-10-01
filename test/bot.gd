extends Node

var cmd_arg: Dictionary

var client: DiscordClient

var something: int

func _init() -> void:
	parse_cmdline_args()

func _ready() -> void:
	client = DiscordClient.new(get_token(), GatewayIntents.ALL)
	# warning-ignore:return_value_discarded
	client.connect("client_ready", self, "_on_ready")
	add_child(client)
	client.login()

func parse_cmdline_args() -> void:
	var regex: RegEx = RegEx.new()
	# warning-ignore:return_value_discarded
	regex.compile("--(?<key>\\w+)=\"?(?<value>.+)\"?")
	for arg in OS.get_cmdline_args():
		var result: RegExMatch = regex.search(arg)
		if result:
			cmd_arg[result.get_string("key")] = str2var(result.get_string("value"))

func get_token() -> String:
	return cmd_arg.get("token", "")

func _on_ready(user: User) -> void:
	print("Bot is ready !")
	print("logged as: ", user.username)
