extends KinematicBody2D

####### TODO: switch back to Characters.png once you upgrade to
# Godot 3.1. There's a merged PR for 3.1 that fixes a bug where
# you can't use Animation if you're using Region.

const MINIMUM_MOVE_DISTANCE = 5
var speed = 200
var destination = null
var facing = null # "Walk Left", "Walk Up", etc.

func _ready():
	set_process(true)

func _physics_process(delta):
	self._move_to_keyboard()
	self._move_to_clicked_destination()

func _input(event):
	#if event.is_action_pressed('click'):
	if event is InputEventMouseButton:
		self.destination = get_global_mouse_position()
	
		var new_facing = self.facing
		var direction = self.destination - self.position
		var magnitude = direction.abs()
		
		if magnitude.x > magnitude.y: # more horizontal than vertical
			if direction.x < 0:
				new_facing = "Walk Left"
			else:
				new_facing = "Walk Right"
		else:
			if direction.y < 0:
				new_facing = "Walk Up"
			else:
				new_facing = "Walk Down"
		
		self._change_animation(new_facing)

func _move_to_keyboard():	
	var velocity = Vector2(0, 0)
	var new_facing = self.facing
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = 1
		new_facing = "Walk Right"
	elif Input.is_key_pressed(KEY_LEFT):
		velocity.x = -1
		new_facing = "Walk Left"
	
	if Input.is_key_pressed(KEY_UP):
		velocity.y = -1
		new_facing = "Walk Up"
	elif Input.is_key_pressed(KEY_DOWN):
		velocity.y = 1
		new_facing = "Walk Down"
	
	self._change_animation(new_facing)
	
	if velocity.x != 0 or velocity.y != 0:
		velocity = velocity.normalized() * speed
		move_and_slide(velocity)
	else:
		$AnimationPlayer.stop()

func _move_to_clicked_destination():
	if self.destination != null:
		var velocity = (self.destination - self.position).normalized() * self.speed
		# rotation = velocity.angle() # rotate towards target
		if (destination - position).length() > MINIMUM_MOVE_DISTANCE:
			move_and_slide(velocity)
		else:
			self.destination = null
			$AnimationPlayer.stop()
			
func _change_animation(new_facing):
	if new_facing != self.facing:
		self.facing = new_facing
		$AnimationPlayer.play(self.facing)