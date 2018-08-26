extends Node2D

### Creates a map. Populates tiles => entities (eg. trees).

var TileMapSizer = preload("res://Scripts/TileMapSizer.gd")
var TwoDimensionalArray = preload("res://Scripts/TwoDimensionalArray.gd")
var Warp = preload("res://Entities/Warp.tscn")

# Dictionary of tile name (of the entity in the tileset) to entity scene
# We could use names instead of IDs, but that requires more code to figure out names
const entity_tiles = {
	"Tree": preload("res://Entities/Tree.tscn"),
	"House Door": preload("res://Entities/Door.tscn"),
}

var _warps = []
var _warps_to_remove = []

# TODO: ENUM?
var world_map = TwoDimensionalArray.new(0, 0).load_from([
	["Meadow1", "Meadow2"],
	["Meadow3", "Meadow4"]
])

var maps = {
	# TODO: enum?
	"Meadow1": "res://Maps/Overworld/Meadow1.tscn",
	"Meadow2": "res://Maps/Overworld/Meadow2.tscn",
	"Meadow3": "res://Maps/Overworld/Meadow3.tscn",
	"Meadow4": "res://Maps/Overworld/Meadow4.tscn",
	"Home": "res://Maps/Indoors/Home.tscn"
}

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func create_map(map_name):
	var map = load(maps[map_name]).instance()
	self._populate_entities(map)
	self._setup_warps(map_name, map)
	map.z_index = -1 # draw under the player
	return map

# Find entities on the map (eg. trees). Remove them and replace them with
# real entities (scenes) so that we can have logic (attach scripts) to them.
func _populate_entities(map):
	var possible_tilemaps = map.get_children()
	for tile_map in possible_tilemaps:
		if tile_map is TileMap:
			var tile_set = tile_map.tile_set
			for cell in tile_map.get_used_cells():
				var tile_id = tile_map.get_cellv(cell)
				var tile_name = tile_set.tile_get_name(tile_id)
				if entity_tiles.has(tile_name):
					# Spawn + replace with entity of the same name
					var scene = entity_tiles[tile_name]
					var instance = scene.instance()
					map.add_child(instance)
					instance.position.x = cell.x * Globals.TILE_WIDTH
					instance.position.y = cell.y * Globals.TILE_HEIGHT
					# Remove tile
					tile_map.set_cellv(cell, -1)

# TODO: move this to an AutoWarp constructor/factory/etc
func _setup_warps(current_map_name, map):
	
	for warp in self._warps:
		# Can't call _warps.remove this inside a signal. Crashes on Android.
		self._warps_to_remove.append(warp)
		warp.queue_free()
	
	call_deferred("_remove_warps", map)
	
	_warps = []
	
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
		
		var map_size_metadata = TileMapSizer.get_map_size_in_pixels(map)
		
		var map_size_tiles = map_size_metadata[0]
		var tile_size_pixels = map_size_metadata[1]
		var map_size_pixels = map_size_metadata[2]
		
		if warp_data.has("right"):
			_create_warp(map, warp_data["right"],
				map_size_pixels.x - tile_size_pixels.x, tile_size_pixels.y,
				1, map_size_tiles.y - 2,
				2 * tile_size_pixels.x, null)
		
		if warp_data.has("left"):
			_create_warp(map, warp_data["left"],
				0, tile_size_pixels.y,
				1, map_size_tiles.y - 2,
				map_size_pixels.x - (2 * tile_size_pixels.x), null)
			
		if warp_data.has("down"):
			_create_warp(map, warp_data["down"],
				tile_size_pixels.x, map_size_pixels.y - tile_size_pixels.y,
				map_size_tiles.x - 2, 1,
				null, 2 * tile_size_pixels.y)
		
		if warp_data.has("up"):
			_create_warp(map, warp_data["up"],
				tile_size_pixels.x, 0,
				map_size_tiles.x - 2, 1,
				# 2.5x because map size != screen size
				null, map_size_pixels.y - (2.5 * tile_size_pixels.y))
				

func _create_warp(on_map, target_map, x, y, width_in_tiles, height_in_tiles, target_player_x, target_player_y):
	var w = Warp.instance()
	w.is_auto_setup = true
	
	w.setup(target_map, x, y, width_in_tiles, height_in_tiles, target_player_x, target_player_y)
	on_map.add_child(w)

func _remove_warps(owning_map):
	# Can't do this inside a signal; doing so Crashes on Android.
	# This has to be in call_deferred.
	for warp in self._warps_to_remove:
		owning_map.remove_child(warp)
		
	self._warps_to_remove = []