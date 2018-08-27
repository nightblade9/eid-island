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

func get_width():
	return self.get_node("Sprite").region_rect.size.x

func get_height():
	var region_height = self.get_node("Sprite").region_rect.size.y
	var num_vframes = self.get_node("Sprite").vframes
	return region_height / num_vframes

func collect_wood(amount):
	self.wood_collected += amount
	SignalManager.emit_signal("wood_changed", self.wood_collected)

func sell_wood(coins_per_wood):
	self.coins += (self.wood_collected * coins_per_wood)
	self.wood_collected = 0
	SignalManager.emit_signal("coins_changed", self.coins)
	SignalManager.emit_signal("wood_changed", self.wood_collected)

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

func _on_MoveToKeyboard_cancel_destination():
	self._cancel_mouse_destination()

func _cancel_mouse_destination():
	$MoveToMouseClick.cancel_destination()
