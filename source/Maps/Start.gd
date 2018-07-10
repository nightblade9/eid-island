extends Node2D

var current_map
var maps = {
	"meadow1": "res://Maps/Overworld/Meadow1.tscn",
	"meadow2": "res://Maps/Overworld/Meadow2.tscn",
	"meadow3": "res://Maps/Overworld/Meadow3.tscn",
	"meadow4": "res://Maps/Overworld/Meadow4.tscn"
}
const STARTING_MAP = "meadow1"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.current_map = load(maps[STARTING_MAP]).instance()
	self.current_map.z_index = -1 # draw under the player
	self.add_child(self.current_map)
	# TODO: center player

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass