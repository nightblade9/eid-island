extends KinematicBody2D

####### TODO: switch back to Characters.png once you upgrade to
# Godot 3.1. There's a merged PR for 3.1 that fixes a bug where
# you can't use Animation if you're using Region.

var speed = 200
var destination = null # from mouse component
var facing = null # "Left", "Up", etc.

func _init():
	Globals.player = self

func _ready():
	set_process(true)
	SignalManager.connect("map_changed", self, "_on_map_change")

func _physics_process(delta):
	self._move_to_keyboard()

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
		self.destination = null # if clicked, cancel that destination
	else:
		# Not moving and not click-move: stop animation
		if self.destination == null:
			$AnimationPlayer.stop()
			
func _change_animation(new_facing):
	if new_facing != self.facing:
		self.facing = new_facing
		$AnimationPlayer.play("Walk " + self.facing)

func _on_map_change():
	self.destination = null
	self.facing = "" # fixes bug: after warping, clicking didn't animate