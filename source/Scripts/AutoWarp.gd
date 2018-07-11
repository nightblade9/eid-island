extends Node

# dictionary of string/enum to map name, eg. { "left" => "meadow2" }
var warp_data = {}
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _init(warp_data, current_map):
	self.warp_data = warp_data
	load("res://Entities/Player.gd")
	print("Auto-warp reportin'")
	
	var max_dimensions = Vector2(0, 0)
	
	# Figure out the map size from the largest tileset
	# We can use this to tell where (x, y) coordinates we need
	# to add warps (on the edges of the maps).
	var children = current_map.get_children()
	for child in children:
		if child is TileMap:
			var dimensions = child.get_used_rect()
			var map_width = dimensions.size.x
			var map_height = dimensions.size.y
			
			if map_width > max_dimensions.x:
				max_dimensions.x = map_width
			if map_height > max_dimensions.y:
				max_dimensions.y = map_height
	
	print(max_dimensions)
			
	
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
