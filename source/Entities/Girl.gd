extends KinematicBody2D

const MINIMUM_MOVE_DISTANCE = 5
var speed = 200
var destination = null

func _ready():
	set_process(true)

func _physics_process(delta):
	self._move_to_keyboard()
	self._move_to_clicked_destination()

func _input(event):
	#if event.is_action_pressed('click'):
	if event is InputEventMouseButton:
		self.destination = get_global_mouse_position()

func _move_to_keyboard():
	var velocity = Vector2(0, 0)
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = 1
	elif Input.is_key_pressed(KEY_LEFT):
		velocity.x = -1
	
	if Input.is_key_pressed(KEY_UP):
		velocity.y = -1
	elif Input.is_key_pressed(KEY_DOWN):
		velocity.y = 1
	
	velocity = velocity.normalized() * speed
	move_and_slide(velocity)

func _move_to_clicked_destination():
	if self.destination != null:
		var velocity = (self.destination - self.position).normalized() * self.speed
		# rotation = velocity.angle() # rotate towards target
		if (destination - position).length() > MINIMUM_MOVE_DISTANCE:
			move_and_slide(velocity)
		else:
			# You have arrived! Not technically necessary
			self.destination = null
			