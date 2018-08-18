extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

static func get_map_size_in_pixels(current_map):
	var max_dimensions_in_tiles = Vector2(0, 0)
	
	# Figure out the map size from the largest tileset
	# We can use this to tell where (x, y) coordinates we need
	# to add warps (on the edges of the maps).
	var children = current_map.get_children()
	var tile_size = null
	
	for child in children:
		if child is TileMap:
			var dimensions = child.get_used_rect()
			var map_width = dimensions.size.x
			var map_height = dimensions.size.y
			
			if map_width > max_dimensions_in_tiles.x:
				max_dimensions_in_tiles.x = map_width
			if map_height > max_dimensions_in_tiles.y:
				max_dimensions_in_tiles.y = map_height
			
			if tile_size == null:
				tile_size = child.cell_size
	
	var map_size_tiles = Vector2(int(max_dimensions_in_tiles.x), int(max_dimensions_in_tiles.y))
	var map_size_in_pixels = Vector2(map_size_tiles.x * tile_size.x, map_size_tiles.y * tile_size.y)
	
	var to_return = [map_size_tiles, tile_size, map_size_in_pixels]
	print("map size in tiles="+str(map_size_tiles) + ", px=" + str(map_size_in_pixels))
	return to_return

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
