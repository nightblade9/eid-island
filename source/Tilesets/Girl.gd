extends Node2D

var speed = 100
var vel = Vector2()


func _ready():
	set_process(true)

func _process(delta):
	if Input.is_key_pressed(KEY_RIGHT):
		vel = Vector2(speed, 0)
	elif Input.is_key_pressed(KEY_LEFT):
		vel = Vector2(-speed, 0)
	elif Input.is_key_pressed(KEY_UP):
		vel = Vector2(0, -speed)
	elif Input.is_key_pressed(KEY_DOWN):
		vel = Vector2(0, speed)
	else:
		vel = Vector2(0, 0)
	
	self.position.x = self.position.x + (vel.x * delta)
	self.position.y = self.position.y + (vel.y * delta)