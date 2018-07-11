extends Area2D

export var target_map = ""
var target_player_x # null or int
var target_player_y # null or int

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func setup(target_map, x, y, tiles_wide, tiles_high, target_player_x, target_player_y):
	self.target_map = target_map
	self.position.x = x
	self.position.y = y
	self.scale.x = tiles_wide
	self.scale.y = tiles_high
	self.target_player_x = target_player_x
	self.target_player_y = target_player_y

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	# Facing is not quite accurate. I guess it'll do for now?
	# TODO: look at player position. Near bottom = transition down
	var player = get_tree().get_root().get_node("MainMap").get_node("Player")
	
	if player != body:
		return
		
	# TODO: verify that `body` really is the player.
	# For now, nothing else moves, so we should be ok.
	get_tree().get_root().get_node("MainMap").show_map(self.target_map)
	
	if self.target_player_x != null:
		player.position.x = target_player_x
	if self.target_player_y != null:
		player.position.y = target_player_y
	
	SignalManager.emit_signal("map_changed")
