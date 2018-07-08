extends KinematicBody2D

var speed = 200
var vel = Vector2()


func _ready():
	set_process(true)

func _physics_process(delta):
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