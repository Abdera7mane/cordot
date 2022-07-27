class_name UUID

## Author: Binogure Studio
## Original source: https://github.com/binogure-studio/godot-uuid/

const MODULO_8_BIT: int = 256


static func get_random_int() -> int:
	var rng: RandomNumberGenerator

	var uuid: = UUID as Script
	if uuid.has_meta("rng"):
		rng = uuid.get_meta("rng")
	else:
		rng = RandomNumberGenerator.new()
		uuid.set_meta("rng", rng)

	# Randomize every time to minimize the risk of collisions
	rng.randomize()
	return rng.randi_range(0, MODULO_8_BIT - 1)

static func uuidbin() -> PackedByteArray:
	# 16 random bytes with the bytes on index 6 and 8 modified
	return PackedByteArray([
		get_random_int(), get_random_int(), get_random_int(), get_random_int(),
		get_random_int(), get_random_int(), ((get_random_int()) & 0x0f) | 0x40, get_random_int(),
		((get_random_int()) & 0x3f) | 0x80, get_random_int(), get_random_int(), get_random_int(),
		get_random_int(), get_random_int(), get_random_int(), get_random_int(),
	])

static func v4() -> String:
	# 16 random bytes with the bytes on index 6 and 8 modified
	var b: PackedByteArray = uuidbin()

	return '%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x' % [
		# low
		b[0], b[1], b[2], b[3],

		# mid
		b[4], b[5],

		# hi
		b[6], b[7],

		# clock
		b[8], b[9],

		# clock
		b[10], b[11], b[12], b[13], b[14], b[15]
	]
