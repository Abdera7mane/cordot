class_name MessageSticker extends DiscordEntity

enum Format {
	PNG,
	APNG,
	LOTTIE
}

var name: String          setget __set
var description: String   setget __set
var pack_id: int          setget __set
var tags: PoolStringArray setget __set
var asset: String         setget __set
var preview_asset: String setget __set
var format_type: int      setget __set

func _init(data: Dictionary).(data.id) -> void:
	name = data["name"]
	description = data["description"]
	pack_id = data["pack_id"] as int
	if data.has("tags"):
		tags = PoolStringArray(data["tags"].split(",", false))
	asset = data["asset"]
	preview_asset = GDUtil.get_or_default(data, "preview_asset", "")
	format_type = data["format_type"]

func get_class() -> String:
	return "MessageSelectMenu"

func __set(_value) -> void:
	.__set(_value)
