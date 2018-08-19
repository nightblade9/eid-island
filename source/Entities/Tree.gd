extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var health = 3

func _ready():
	print("Tree ready")
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	print("Wewt")
		
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	# Click to move on PC, touch to move on Android
	# Touch/drag to move on Android
	if (event is InputEventMouseButton and event.pressed) or (OS.has_feature("Android") and event is InputEventMouseMotion):
		var clicked_on = event.position
		var tree_size = self.region_rect
		var my_bounds = Rect2(self.position.x, self.position.y, tree_size.size.x, tree_size.size.y)
		
		var test = my_bounds.has_point(clicked_on)
		print("Test=" + str(test))
		
		if my_bounds.has_point(clicked_on):
			
			var player = Globals.player
			
			if sqrt(
				pow(self.position.x - player.position.x, 2) + 
				pow(self.position.y - player.position.y, 2)) < Globals.TILE_WIDTH:
					self.health -= 1
					print("Tree heatlh decreased to " + str(self.health))


func _on_Area2D_input_event(viewport, event, shape_idx):
	# Click to move on PC, touch to move on Android
	# Touch/drag to move on Android
	if (event is InputEventMouseButton and event.pressed) or (OS.has_feature("Android") and event is InputEventMouseMotion):
		var player = Globals.player
		
		if sqrt(
			pow(self.position.x - player.position.x, 2) + 
			pow(self.position.y - player.position.y, 2)) < Globals.TILE_WIDTH:
				self.health -= 1
				print("Tree heatlh decreased to " + str(self.health))
