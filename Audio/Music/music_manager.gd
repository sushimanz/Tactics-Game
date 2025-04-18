class_name MusicManager
extends AudioStreamPlayer

const intro: Array = ["res://Audio/Music/Intro.wav"]
const select: Array = ["res://Audio/Music/Select.wav", "res://Audio/Music/Select Loop.wav"]

@export var is_loop := true

func _init() -> void:
	#Set to 1% volume so ears don't get blasted
	volume_linear = 0.01

#For use in settings menu
func set_music_volume(volume_pct: float):
	volume_linear = volume_pct

func play_track(track_url: String):
	#print("Playing track ", track_url)
	var track = load(track_url)
	stream = track
	play()

func stop_track():
	stop()

func _on_finished() -> void:
	#print("Music Ended")
	if is_loop:
		play()
