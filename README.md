# Giscord

Discord API wrapper for [Godot Engine](https://github.com/godotengine/godot) written in **GDScript** language.

<p align="center">
  <img src="screenshots/ping-pong.png" alt="Material Bread logo">
</p>

![Godot version](https://img.shields.io/static/v1?label=Godot&message=3.5.x&color=478cbf&style=for-the-badge&logo=godotengine&logoColor=white)
![Discord API version](https://img.shields.io/static/v1?label=Discord%20API&message=V8&color=5865f2&style=for-the-badge&logo=discord&logoColor=white)
![License](https://img.shields.io/github/license/abdera7mane/Giscord?style=for-the-badge)

# Features

* Object oriented
* Statically typed
* Supports gateway resumes and auto reconnects when possible

## Example

A minimal bot written using this library

```gdscript
extends Node

var token: String = "bot_token"
var client: DiscordClient = DiscordClient.new(token)

func _ready() -> void:
    add_child(client)
    
    client.connect("client_ready", self, "_on_bot_ready")
    client.connect("message_sent", self, "_on_message")

    client.login()

func _on_bot_ready(user: User) -> void:
    print("Bot is ready !")
    print("logged as: ", user.get_tag())

    var presence := PresenceUpdate.new()
    presence.set_status(Presence.Status.DND)\
            .add_activity(Presence.playing("Godot Engine"))

    client.update_presence(presence)

func _on_message(message: Message) -> void:
    if message.user.is_bot:
        return

    if message.content.to_lower().begins_with("hello"):
        message.channel.send_message("Greetings !")

```

## Installation


```
git clone --recursive https://github/Abdera7mane/Giscord.git
cd Giscord
git submodule update --init --recursive
```
Open the folder as a Godot project or copy the `addons` directory to an existing project.

## Documentation

Not available, there will be one after publishing a usable release of the library

## Usage

Even though this may seem useless for a Godot game, I find this project being useful in some scenarios:
* Learning resource
* Running a discord bot in a Godot game server

It is always up to you and your creativity on how you will use this project as long as you **don't abuse the Discord API**.