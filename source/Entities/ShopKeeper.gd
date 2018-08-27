extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const COINS_PER_WOOD = 1

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_Area2D_body_entered(body):
	var player = Globals.player
	
	if body == player and player.wood_collected > 0:
		player.sell_wood(COINS_PER_WOOD)
		Globals.audio_manager.play_sound("sell_item")