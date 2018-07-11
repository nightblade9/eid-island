extends Node2D

var current_map = null
var autowarp = null

var maps = {
	# TODO: enum?
	"meadow1": "res://Maps/Overworld/Meadow1.tscn",
	"meadow2": "res://Maps/Overworld/Meadow2.tscn",
	"meadow3": "res://Maps/Overworld/Meadow3.tscn",
	"meadow4": "res://Maps/Overworld/Meadow4.tscn",
	"blank": "res://Maps/Overworld/Blank.tscn"
}

var TwoDimensionalArray = preload("res://Scripts/TwoDimensionalArray.gd")
var AutoWarp = preload("res://Scripts/AutoWarp.gd")

# TODO: ENUM?
var world_map = TwoDimensionalArray.new(0, 0).load_from([
	["meadow1", "meadow2"],
	["meadow3", "meadow4", "blank"],
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
	
	self._setup_warps(map_name)

# TODO: move this to an AutoWarp constructor/factory/etc
func _setup_warps(current_map_name):
	var map_coordinates = self.world_map.find(current_map_name)
	var warp_data = {} # TODO: add enum
	
	if map_coordinates.x < self.world_map.width && self.world_map.has(map_coordinates.x + 1, map_coordinates.y):
		warp_data["right"] = self.world_map.get(map_coordinates.x + 1, map_coordinates.y)
	if map_coordinates.x > 0 && self.world_map.has(map_coordinates.x - 1, map_coordinates.y):
		warp_data["left"] = self.world_map.get(map_coordinates.x - 1, map_coordinates.y)
	if map_coordinates.y < self.world_map.height && self.world_map.has(map_coordinates.x, map_coordinates.y + 1):
		warp_data["down"] = self.world_map.get(map_coordinates.x, map_coordinates.y + 1)
	if map_coordinates.y > 0 && self.world_map.has(map_coordinates.x, map_coordinates.y - 1):
		warp_data["up"] = self.world_map.has(map_coordinates.x, map_coordinates.y - 1)
	
	self.autowarp = AutoWarp.new(warp_data, self.current_map)