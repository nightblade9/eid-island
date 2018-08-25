extends Node2D

var current_map = null

var MapCreator = preload("res://Scripts/MapCreator.gd")

const STARTING_MAP = "Meadow1"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.show_map(STARTING_MAP)
	
	var game_dimensions = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var player = get_node("Player")
	player.position.x = 0
	player.position.y = 0
	
func show_map(map_name):
	Globals.audio_manager.clean_up_audio()
	
	if self.current_map != null:
		self.current_map.queue_free()
	
	self.current_map = MapCreator.new().create_map(map_name)
	self.add_child(self.current_map)