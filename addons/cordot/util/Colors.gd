class_name Colors

static func from_rgb24(rgb: int) -> Color:
	var red: int = (rgb >> 16) & 0xFF
	var green: int = (rgb >> 8) & 0xFF
	var blue: int = rgb & 0xFF
	return Color8(red, green, blue)
