extends Area2D

export var target_map = ""
export var target_player_x = -1 # nullable int
export var target_player_y = -1 # nullable int
var is_auto_setup = false
export var id = 0

# By default, creates a 1x1 warp using external variables.
func _init():
	self.id = Globals.NEXT_WARP_ID
	Globals.NEXT_WARP_ID += 1
	
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
	# Scaling is simple but does it butcher collision detection? Probably.
	# Resizing dynamically doesn't work -- no APIs to set ColorRect size.
	self.scale.x = tiles_wide
	self.scale.y = tiles_high

func _on_Area2D_body_entered(body):
	var player = Globals.player
	
	# This method is called for other things like tilemaps
	if body != player:
		return
	
	print("*** Triggered warp #" + str(self.id) + "; warp is at " + str(self.position) + ", body is at " + str(body.position))
	
	get_tree().get_root().get_node("MainMap").show_map(self.target_map)
	
	if self.target_player_x != null:
		player.position.x = target_player_x
	if self.target_player_y != null:
		player.position.y = target_player_y

	print("*** Warped with warp #" + str(self.id))
	SignalManager.emit_signal("map_changed")
