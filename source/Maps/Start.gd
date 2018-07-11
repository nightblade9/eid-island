extends Node2D

var current_map

var maps = {
	"meadow1": "res://Maps/Overworld/Meadow1.tscn",
	"meadow2": "res://Maps/Overworld/Meadow2.tscn",
	"meadow3": "res://Maps/Overworld/Meadow3.tscn",
	"meadow4": "res://Maps/Overworld/Meadow4.tscn"
}

var TwoDimensionalArray = preload("res://Scripts/TwoDimensionalArray.gd")

var world_map = TwoDimensionalArray.new(3, 2).load_from([
	["meadow1", "meadow2", "blank"],
	["meadow3", "meadow4"],
])

const STARTING_MAP = "meadow1"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.show_map(STARTING_MAP)
	# TODO: center player
	var game_dimensions = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var player = get_node("Player")
	player.position.x = game_dimensions.x / 2
	player.position.y = game_dimensions.y / 2

func show_map(map_name):
	if self.current_map != null:
		self.current_map.queue_free()
		
	self.current_map = load(maps[map_name]).instance()
	self.current_map.z_index = -1 # draw under the player
	self.add_child(self.current_map)