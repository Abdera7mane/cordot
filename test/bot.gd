extends Node

# warning-ignore-all:return_value_discarded

var cmd_arg: Dictionary
var client: DiscordClient

func _init() -> void:
	parse_cmdline_args()

func _ready() -> void:
	client = DiscordClient.new(get_token(), GatewayIntents.ALL)
	add_child(client)
	
	client.connect("client_ready", self, "_on_ready")
	client.connect("message_sent", self, "_on_message")
	
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

func _on_message(message: Message) -> void:
	if message.content == "?ping":
		var start: int = Time.get_ticks_msec()
		var content = "**Gateway ping**: %d" % client.get_ping()
		var message_sent: Message = yield(message.channel.send_message(content), "completed")
		content = content + ", **REST ping**: %d" % (Time.get_ticks_msec() - start)
		yield(message_sent.edit(content), "completed")
