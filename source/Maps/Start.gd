extends Node2D

const OFFSET_TO_MATCH_TILE_TO_SCREEN = 36

var current_map = null
var _warps = []

var maps = {
	# TODO: enum?
	"Meadow1": "res://Maps/Overworld/Meadow1.tscn",
	"Meadow2": "res://Maps/Overworld/Meadow2.tscn",
	"Meadow3": "res://Maps/Overworld/Meadow3.tscn",
	"Meadow4": "res://Maps/Overworld/Meadow4.tscn",
	"Blank": "res://Maps/Overworld/Blank.tscn"
}

var TwoDimensionalArray = preload("res://Scripts/TwoDimensionalArray.gd")
var TileMapSizer = preload("res://Scripts/TileMapSizer.gd")
var Warp = preload("res://Entities/Warp.tscn")

# TODO: ENUM?
var world_map = TwoDimensionalArray.new(0, 0).load_from([
	["Meadow1", "Meadow2"],
	["Meadow3", "Meadow4"]
])

const STARTING_MAP = "Meadow1"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.show_map(STARTING_MAP)
	# TODO: center player
	var game_dimensions = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var player = get_node("Player")
#	player.position.x = game_dimensions.x / 2
#	player.position.y = game_dimensions.y / 2
	player.position.x = 0
	player.position.y = 0
	
func show_map(map_name):
	if self.current_map != null:
		self.current_map.queue_free()
		
	self.current_map = load(maps[map_name]).instance()
	self.current_map.z_index = -1 # draw under the player
	# TODO: set the "Ground" layer only to z-index -1
	# If there is none, set the first tileset z-index to -1
	self.add_child(self.current_map)
	
	self._setup_warps(map_name)

# TODO: move this to an AutoWarp constructor/factory/etc
func _setup_warps(current_map_name):
	var map_coordinates = self.world_map.find(current_map_name)
	
	if map_coordinates != null: # map exists in the grid
		var warp_data = {} # TODO: add enum
		
		if map_coordinates.x + 1 < self.world_map.width && self.world_map.has(map_coordinates.x + 1, map_coordinates.y):
			warp_data["right"] = self.world_map.get(map_coordinates.x + 1, map_coordinates.y)
		if map_coordinates.x - 1 >= 0 && self.world_map.has(map_coordinates.x - 1, map_coordinates.y):
			warp_data["left"] = self.world_map.get(map_coordinates.x - 1, map_coordinates.y)
		if map_coordinates.y + 1 < self.world_map.height && self.world_map.has(map_coordinates.x, map_coordinates.y + 1):
			warp_data["down"] = self.world_map.get(map_coordinates.x, map_coordinates.y + 1)
		if map_coordinates.y - 1 >= 0 && self.world_map.has(map_coordinates.x, map_coordinates.y - 1):
			warp_data["up"] = self.world_map.get(map_coordinates.x, map_coordinates.y - 1)
		
		var map_size_metadata = TileMapSizer.get_map_size_in_pixels(self.current_map)
		
		var map_size_tiles = map_size_metadata[0]
		var tile_size_pixels = map_size_metadata[1]
		var map_size_pixels = map_size_metadata[2]
	
		for warp in self._warps:
			# Can't do this inside a signal. Crashes on Android.
			# self.remove_child(warp)
			warp.queue_free()
		
		_warps = []
		
		if warp_data.has("right"):
			self._create_warp(warp_data["right"],
				map_size_pixels.x - tile_size_pixels.x, 0,
				1, map_size_tiles.y,
				2 * tile_size_pixels.x, null)
		
		if warp_data.has("left"):
			self._create_warp(warp_data["left"],
				0, 0,
				1, map_size_tiles.y,
				map_size_pixels.x - (2 * tile_size_pixels.x), null)
			
		if warp_data.has("down"):
			self._create_warp(warp_data["down"],
				0, map_size_pixels.y - tile_size_pixels.y - OFFSET_TO_MATCH_TILE_TO_SCREEN,
				map_size_tiles.x, 1,
				null, 2 * tile_size_pixels.y)
		
		if warp_data.has("up"):
			self._create_warp(warp_data["up"],
				0, 0,
				map_size_tiles.x, 1,
				# 2.5x because map size != screen size
				null, map_size_pixels.y - (2 * tile_size_pixels.y))

func _create_warp(target_map, x, y, width_in_tiles, height_in_tiles, target_player_x, target_player_y):
	var w = Warp.instance()
	w.is_auto_setup = true
	
	w.setup(target_map, x, y, width_in_tiles, height_in_tiles, target_player_x, target_player_y)
	self._warps.append(w)
	self.add_child(w)
