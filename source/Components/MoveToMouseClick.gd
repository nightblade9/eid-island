###
# Moves the parent to the specified target (mouse-click).
# On Android, moves to the touched location.
###
extends Node2D

const MINIMUM_MOVE_DISTANCE = 5

signal facing_new_direction # we're facing a new direction as a result of clicking
signal reached_destination # stop moving please and thanks

export var speed = 0

var destination = null # Vector2

func _ready():
	############ TODO: assigng self.animation to player animatino
	
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
		self.destination = get_global_mouse_position()
	
		var new_facing = ""
		var direction = self.destination - self.get_parent().position
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
		
		# Even if you didn't change directions, restart animation.
		# You may have moved down, then reached, now move down again
		self.emit_signal("facing_new_direction", new_facing)

func cancel_destination():
	self.destination = null

func _move_parent_to_clicked_destintion():
	var destination = self.destination
	var position = self.get_parent().position
	
	if destination != null:
		var velocity = (destination - position).normalized() * self.speed
		# rotation = velocity.angle() # rotate towards target
		if (destination - position).length() > MINIMUM_MOVE_DISTANCE:
			self.get_parent().move_and_slide(velocity)
		else:			
			self.emit_signal("reached_destination")
