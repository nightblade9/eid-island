extends Area2D

export var target_map = ""
export var target_player_x = -1 # nullable int
export var target_player_y = -1 # nullable int

var is_auto_setup = false

# By default, creates a 1x1 warp using external variables.
func _init():
	# If it's not auto-setup, it's already manually positioned/sized on the map
	# We don't need to size it, set the target, etc.
	if not self.is_auto_setup:
		self.setup(target_map, self.position.x, self.position.y, 1, 1, target_player_x, target_player_y)
	
func setup(target_map, x, y, tiles_wide, tiles_high, target_player_x, target_player_y):
	self.target_map = target_map
	self.position.x = x
	self.position.y = y
	self.target_player_x = target_player_x
	self.target_player_y = target_player_y
	self._resize(tiles_wide, tiles_high)

func _resize(tiles_wide, tiles_high):
	self.scale.x = tiles_wide
	self.scale.y = tiles_high

func _on_Area2D_body_entered(body):
	var player = Globals.player
	
	# This method is called for other things like tilemaps
	if body != player:
		return
	
	# This method is called even when bodies don't overlap. If you have three
	# maps in a row (vertically or horizontally), and traverse for the first map,
	# this triggers immediately on the second map -- even when the player is
	# teleported to (200, 200) and the warp is at (48, 480) and wide, not tall.
	# It doesn't make sense. 
	#
	# Introducing a timing delay until the next time you can warp, adds other issues.
	# Instead, trigger this code only if the bodies *actually* overlap.
	#
	# Assume player is one-tile sized.
	#
	var warp_position = Rect2(self.position.x, self.position.y,
			self.scale.x * Globals.TILE_WIDTH,
			self.scale.y * Globals.TILE_HEIGHT)
		
	var player_position = Rect2(body.position.x, body.position.y, Globals.TILE_WIDTH, Globals.TILE_HEIGHT);
	
	print("warp=" + str(warp_position) + ", player=" + str(player_position))
	
	print(str(warp_position.clip(player_position)))
	if not warp_position.intersects(player_position):
		return
	
	get_tree().get_root().get_node("MainMap").show_map(self.target_map)
	
	if self.target_player_x != null:
		player.position.x = target_player_x
	if self.target_player_y != null:
		player.position.y = target_player_y

	SignalManager.emit_signal("map_changed")
