extends Node2D

var speed = 100
var vel = Vector2()


func _ready():
	set_process(true)

func _process(delta):
	var velocity = Vector2(0, 0)
	
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x = velocity.x + speed		
	elif Input.is_key_pressed(KEY_LEFT):
		velocity.x = velocity.x - speed
	
	if Input.is_key_pressed(KEY_UP):
		velocity.y = velocity.y - speed
	elif Input.is_key_pressed(KEY_DOWN):
		velocity.y = velocity.y + speed
	
	self.position.x = self.position.x + (velocity.x * delta)
	self.position.y = self.position.y + (velocity.y * delta)