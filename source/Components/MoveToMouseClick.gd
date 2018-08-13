###
# Moves the parent to the specified target (mouse-click).
# On Android, moves to the touched location.
###
extends Node2D

const MINIMUM_MOVE_DISTANCE = 5

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	self._move_parent_to_clicked_destintion()

func _input(event):
	# Click to move on PC, touch to move on Android
	# Touch/drag to move on Android
	if (event is InputEventMouseButton and event.pressed) or (OS.has_feature("Android") and event is InputEventMouseMotion):
		self.get_parent().destination = get_global_mouse_position()
	
		var new_facing = self.get_parent().facing
		var direction = self.get_parent().destination - self.get_parent().position
		var magnitude = direction.abs()
		
		if magnitude.x > magnitude.y: # more horizontal than vertical
			if direction.x < 0:
				new_facing = "Left"
			else:
				new_facing = "Right"
		else:
			if direction.y < 0:
				new_facing = "Up"
			else:
				new_facing = "Down"
		
		# TODO: broadcast("update animation(new_facing)")
		#self._change_animation(new_facing)
		
func _move_parent_to_clicked_destintion():
	var destination = self.get_parent().destination
	var position = self.get_parent().position
	var speed = self.get_parent().speed
	
	if destination != null:
		var velocity = (destination - position).normalized() * speed
		# rotation = velocity.angle() # rotate towards target
		if (destination - position).length() > MINIMUM_MOVE_DISTANCE:
			self.get_parent().move_and_slide(velocity)
		else:
			self.get_parent().destination = null
			# TODO: broadcast(arrived at destination)
			self.get_parent().get_node("AnimationPlayer").stop()
