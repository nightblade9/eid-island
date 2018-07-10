extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	load("res://Entities/Player.gd")
	print("Auto-warp reportin'")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	self.connect("player_moved", self, "_on_player_moved")

func _on_player_moved(position, facing):
	print("Player moved to " + str(position) + " and is facing " + facing)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
