extends Node

###### SOURCE: https://godot.readthedocs.io/en/3.0/tutorials/3d/fps_tutorial/part_six.html#doc-fps-tutorial-part-six
# ------------------------------------
# All of the audio files.

# You will need to provide your own sound files.
var audio_clips = {
	"tree_hit": preload("res://assets/audio/tree_hit.wav"),
	"tree_break": preload("res://assets/audio/tree_breaks.wav"),
	"sell_item": preload("res://assets/audio/sell_item.wav"),
	"open_door": preload("res://assets/audio/open_door.wav")
}

const AudioFilePlayerClass = preload("res://Utilities/AudioFilePlayer.tscn")
var audio_instances = []

func play_sound(sound_name, loop_sound=false, sound_position=null):
	if audio_clips.has(sound_name):
		var audio_player = AudioFilePlayerClass.instance()
		
		Globals.add_child(audio_player)
		audio_instances.append(audio_player)
		
		audio_player.should_loop = loop_sound
		audio_player.play_sound(audio_clips[sound_name], sound_position)
		audio_player.connect("sound_finished", self, "remove_sound")
	else:
		print ("ERROR: cannot play sound that does not exist in audio_clips!")
# ------------------------------------

func remove_sound(audio):
	var index = audio_instances.find(audio)
	audio_instances.remove(index)

func clean_up_audio():
	for sound in audio_instances:
		if (sound != null):
			sound.queue_free()
		
	audio_instances.clear()