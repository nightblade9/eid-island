extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _on_Area2D_body_entered(body):
	var player = Globals.player
	
	if body == player and player.wood_collected > 0:
		player.coins += player.wood_collected
		player.wood_collected = 0
		print("Player now has " + str(player.coins) + " coins")
		Globals.play_sound("sell_item")