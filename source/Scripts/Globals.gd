extends Node

var player
var audio_manager = preload("res://Scripts/AudioManager.gd").new()

# TODO: update all the code, everywhere, to reference this value
const TILE_WIDTH = 48
const TILE_HEIGHT = 48

# Returns integer value from min to max inclusive
# Source: https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number
func randint(minimum, maximum):
	return range(minimum, maximum + 1)[randi() % range(minimum, maximum + 1).size()]
