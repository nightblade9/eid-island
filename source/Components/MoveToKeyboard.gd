extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal cancel_destination
signal reached_destination
signal facing_new_direction

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self._move_to_keyboard()

func _move_to_keyboard():	
	var velocity = Vector2(0, 0)
	var new_facing = self.get_parent().facing
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = 1
		new_facing = "Right"
	elif Input.is_key_pressed(KEY_LEFT):
		velocity.x = -1
		new_facing = "Left"
	
	if Input.is_key_pressed(KEY_UP):
		velocity.y = -1
		new_facing = "Up"
	elif Input.is_key_pressed(KEY_DOWN):
		velocity.y = 1
		new_facing = "Down"
	
	if new_facing != self.get_parent().facing:
		self.get_parent().facing = new_facing
		emit_signal("facing_new_direction")
	
	if velocity.x != 0 or velocity.y != 0:
		velocity = velocity.normalized() * self.get_parent().speed
		self.get_parent().move_and_slide(velocity)
		self.emit_signal("cancel_destination") # if clicked, cancel that destination
	else:
		# Not moving and not click-move: stop animation
		if self.get_parent().destination == null:
			self.emit_signal("reached_destination")
			