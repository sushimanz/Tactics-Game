class_name MusicManager
extends AudioStreamPlayer

const intro: Array = ["res://Audio/Music/Intro.wav"]
const select: Array = ["res://Audio/Music/Select.wav", "res://Audio/Music/Select Loop.wav"]

var is_loop := false

func _init() -> void:
	#Set to 1% volume so ears don't get blasted
	self.volume_linear = 0.01

func set_music_volume(volume_pct: float):
	self.volume_linear = volume_pct

func play_track(track_url: String):
	var track = load(track_url)
	self.stream = track
	self.play()

func stop_track():
	self.stop()

#Not sure why but it will not freaking loop the music
func _on_finished() -> void:
	if is_loop:
		self.play()
