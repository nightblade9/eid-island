extends KinematicBody2D

####### TODO: switch back to Characters.png once you upgrade to
# Godot 3.1. There's a merged PR for 3.1 that fixes a bug where
# you can't use Animation if you're using Region.

const MINIMUM_MOVE_DISTANCE = 5
var speed = 200
var destination = null
var facing = null # "Left", "Up", etc.
# BUG: on_Area2D_body_entered triggers multiple times if you have a column
# or row of 3+ consecutive maps. Not sure why. Hack: don't teleport twice 
# in less than, say, 0.1s.
var last_teleport_time = OS.get_unix_time()

func _init():
	Globals.player = self

func _ready():
	set_process(true)
	SignalManager.connect("map_changed", self, "_on_map_change")

func _physics_process(delta):
	self._move_to_keyboard()
	self._move_to_clicked_destination()

func _input(event):
	if event is InputEventMouseButton:
		self.destination = get_global_mouse_position()
	
		var new_facing = self.facing
		var direction = self.destination - self.position
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
		
		self._change_animation(new_facing)

func get_width():
	return self.get_node("Sprite").region_rect.size.x

func get_height():
	var region_height = self.get_node("Sprite").region_rect.size.y
	var num_vframes = self.get_node("Sprite").vframes
	return region_height / num_vframes

func _move_to_keyboard():	
	var velocity = Vector2(0, 0)
	var new_facing = self.facing
	
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
	
	self._change_animation(new_facing)
	
	if velocity.x != 0 or velocity.y != 0:
		velocity = velocity.normalized() * speed
		move_and_slide(velocity)
	else:
		# Not moving and not click-move: stop animation
		if self.destination == null:
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
		$AnimationPlayer.play("Walk " + self.facing)

func _on_map_change():
	self.destination = null
	self.last_teleport_time = OS.get_unix_time()
	self.facing = "" # fixes bug: after warping, clicking didn't animate