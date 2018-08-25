extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal cancel_destination
signal reached_destination
signal facing_new_direction

export var speed = 0 # set by owning component

var last_facing = ""

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	self._move_to_keyboard()

func _move_to_keyboard():	
	var velocity = Vector2(0, 0)
	var new_facing = self.last_facing
	
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
	
	if new_facing != self.last_facing:
		emit_signal("facing_new_direction", new_facing)
		last_facing = new_facing
	
	if velocity.x != 0 or velocity.y != 0:
		velocity = velocity.normalized() * self.speed
		self.get_parent().move_and_slide(velocity)
		self.emit_signal("cancel_destination") # if clicked, cancel that destination
	else:
		self.last_facing = null
		# Not moving and not click-move: stop animation
		if self.get_parent().destination == null:
			self.emit_signal("reached_destination")
			