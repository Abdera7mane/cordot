# Giscord

Discord API wrapper for [Godot Engine](https://github.com/godotengine/godot) written in **GDScript** language.
> The addon is in very early stages, and only the websockset connection was partially implemented.  
> More work has to be done especially in implementing Discord REST API

# Features

* Object oriented
* Statically typed

## Example

A minimal bot written using this library

```gdscript
extends Node

var token: String = "bot_token"
var client: DiscordClient

func _ready() -> void:
    client = DiscordClient.new(token)
    # warning-ignore:return_value_discarded
    client.connect("client_ready", self, "_on_bot_ready")
    add_child(client)
    client.login()

func _on_bot_ready(user: User) -> void:
    print("Bot is ready !")
    print("logged as: ", user.username)
```

## Documentation

Not available, there will be one after publishing a usable release of the library

## Usage

Even though this may seem useless for a Godot game, I find this project being useful in some scenarios:
* Learning resource
* Running a discord bot in a Godot game server

It is always up to you and your creativity on how you will use this project as long as you **don't abuse the Discord API**.