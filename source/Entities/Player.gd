extends KinematicBody2D

####### TODO: switch back to Characters.png once you upgrade to
# Godot 3.1. There's a merged PR for 3.1 that fixes a bug where
# you can't use Animation if you're using Region.

var facing = null # "Left", "Up", etc.

# TODO: convert into proper inventory (list of items)
var wood_collected = 0
var coins = 0

func _init():
	Globals.player = self

func _ready():
	set_process(true)
	SignalManager.connect("map_changed", self, "_on_map_change")
	SignalManager.connect("cut_tree", self, "_on_cut_tree")

func get_width():
	return self.get_node("Sprite").region_rect.size.x

func get_height():
	var region_height = self.get_node("Sprite").region_rect.size.y
	var num_vframes = self.get_node("Sprite").vframes
	return region_height / num_vframes

func _change_animation():
	$AnimationPlayer.play("Walk " + self.facing)

func _on_map_change():
	self._cancel_mouse_destination()
	self.facing = "" # fixes bug: after warping, clicking didn't animate
	$AnimationPlayer.stop()

func _on_facing_new_direction(new_direction):
	self.facing = new_direction
	self._change_animation()

func _on_reached_destination():
	self._cancel_mouse_destination()
	$AnimationPlayer.stop()

func _on_cut_tree():
	# Trees give 3-4 wood on cut. TODO: move into tree class, emit
	# signal with parameters (it's not possible in Godot yet)
	self.wood_collected += Globals.randint(3, 4)
	print("Player has " + str(self.wood_collected) + " wood")

func _on_MoveToKeyboard_cancel_destination():
	self._cancel_mouse_destination()

func _cancel_mouse_destination():
	$MoveToMouseClick.cancel_destination()
