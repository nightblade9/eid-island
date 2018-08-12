extends Area2D

export var target_map = ""
export var target_player_x = -1 # nullable int
export var target_player_y = -1 # nullable int
var is_auto_setup = false

const TELEPORT_THRESHOLD_SECONDS = 0.1

# By default, creates a 1x1 warp using external variables.
func _init():
	if not self.is_auto_setup:
		self.setup(target_map, self.position.x, self.position.y, 1, 1, target_player_x, target_player_y)
	
func setup(target_map, x, y, tiles_wide, tiles_high, target_player_x, target_player_y):
	self.target_map = target_map
	self.position.x = x
	self.position.y = y
	self.scale.x = tiles_wide
	self.scale.y = tiles_high
	self.target_player_x = target_player_x
	self.target_player_y = target_player_y

func _on_Area2D_body_entered(body):
	var player = Globals.player
	
	# This method is called for other things like tilemaps
	if body != player:
		return
		
	# When you have three maps in a column, and you're on the top map and move
	# down one map, you immediately warp again to the bottom map. Same for any
	# scenario where we have multiple maps in succession. It's not related to
	# the player position, setting that to -999 or the middle of the scren does
	# not change anything.
	#
	# It's not affected by removing/destroying previous warps, either.
	#
	# It COULD be because we're scaling our Area2D ...
	#
	# I can't figure it out. Instead, just prevent teleporting twice in 0.1s.
	if OS.get_unix_time() - player.last_teleport_time < TELEPORT_THRESHOLD_SECONDS:
		return
		
	get_tree().get_root().get_node("MainMap").show_map(self.target_map)
	
	if self.target_player_x != null:
		player.position.x = target_player_x
	if self.target_player_y != null:
		player.position.y = target_player_y

	SignalManager.emit_signal("map_changed")

