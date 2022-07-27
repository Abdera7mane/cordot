class_name MessageSticker extends DiscordEntity

enum Format {
	PNG,
	APNG,
	LOTTIE
}

var name: String
var description: String
var pack_id: int
var tags: PackedStringArray
var asset: String
var preview_asset: String
var format_type: int

func _init(data: Dictionary) -> void:
	super(data["id"])
	name = data["name"]
	description = data["description"]
	pack_id = data["pack_id"] as int
	if data.has("tags"):
		tags = PackedStringArray(data["tags"].split(",", false))
	asset = data["asset"]
	preview_asset = Dictionaries.get_non_null(data, "preview_asset", "")
	format_type = data["format_type"]

func get_class() -> String:
	return "MessageSelectMenu"

#func __set(_value) -> void:
#	pass
