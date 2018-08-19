extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var CUT_RANGE = Globals.TILE_WIDTH * 2
var health = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	set_process_input(true)

func _input(event):
	# Click to move on PC, touch to move on Android
	# Touch/drag to move on Android
	if (event is InputEventMouseButton and event.pressed) or (OS.has_feature("Android") and event is InputEventMouseMotion):
		var clicked_on = event.position
		var tree_size = self.region_rect
		var my_bounds = Rect2(self.position.x, self.position.y, tree_size.size.x, tree_size.size.y)
		
		var test = my_bounds.has_point(clicked_on)
		
		if my_bounds.has_point(clicked_on):
			
			var player = Globals.player
			
			if sqrt(
				pow(self.position.x - player.position.x, 2) + 
				pow(self.position.y - player.position.y, 2)) < CUT_RANGE:
					self.health -= 1
					if self.health <= 0:
						Globals.play_sound("tree_break")
						self.queue_free()
						self.get_parent().remove_child(self)
						SignalManager.emit_signal("cut_tree")
					else:
						Globals.play_sound("tree_hit")
