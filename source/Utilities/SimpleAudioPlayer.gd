extends Node2D

var audio_node = null

func _ready():
	audio_node = $AudioStreamPlayer2D
	audio_node.connect("finished", self, "destroy_self")
	audio_node.stop()
	
func play_sound(audio_stream, position=null):
	audio_node.stream = audio_stream
	audio_node.play()
	
func destroy_self():
	audio_node.stop()
	queue_free()
