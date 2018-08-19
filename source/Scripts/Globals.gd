extends Node

var player

# TODO: update all the code, everywhere, to reference this value
const TILE_WIDTH = 48
const TILE_HEIGHT = 48

# Returns integer value from min to max inclusive
# Source: https://godotengine.org/qa/2539/how-would-i-go-about-picking-a-random-number
func randint(minimum, maximum):
	return range(minimum, maximum + 1)[randi() % range(minimum, maximum + 1).size()]

###### SOURCE: https://godot.readthedocs.io/en/3.0/tutorials/3d/fps_tutorial/part_six.html#doc-fps-tutorial-part-six
# ------------------------------------
# All of the audio files.

# You will need to provide your own sound files.
var audio_clips = {
    "tree_hit": preload("res://assets/audio/tree_hit.wav"),
    "tree_break": preload("res://assets/audio/tree_breaks.wav")
}

const SIMPLE_AUDIO_PLAYER_SCENE = preload("res://Utilities/SimpleAudioPlayer.tscn")
var created_audio = []

# loop_sound is not used yet
func play_sound(sound_name, loop_sound=false, sound_position=null):
    if audio_clips.has(sound_name):
        var new_audio = SIMPLE_AUDIO_PLAYER_SCENE.instance()

        add_child(new_audio)
        created_audio.append(new_audio)

        new_audio.play_sound(audio_clips[sound_name], sound_position)

    else:
        print ("ERROR: cannot play sound that does not exist in audio_clips!")
# ------------------------------------

func clean_up_audio():
	for sound in created_audio:
		if (sound != null):
	        sound.queue_free()
		
	created_audio.clear()