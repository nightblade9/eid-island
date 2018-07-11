extends Area2D

export var target_map = ""

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func resize(x, y, tiles_wide, tiles_high):
	self.position.x = x
	self.position.y = y
	self.scale.x = tiles_wide
	self.scale.y = tiles_high

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Area2D_body_entered(body):
	# Facing is not quite accurate. I guess it'll do for now?
	# TODO: look at player position. Near bottom = transition down
	var player = get_tree().get_root().get_node("MainMap").get_node("Player")
	if player.facing == "Up":
		player.position.y = self.get_parent().height - player.get_height()
	elif player.facing == "Down":
		player.position.y = player.get_height()
	elif player.facing == "Right":
		pass
	elif player.facing == "Left":
		pass
	
	# TODO: verify that `body` really is the player.
	# For now, nothing else moves, so we should be ok.
	get_tree().get_root().get_node("MainMap").show_map(self.target_map)
