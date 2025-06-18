class_name MusicManager
extends AudioStreamPlayer

@export var is_loop: bool = true

var randomize_track: bool = false
var loaded_track: String = ""
var loaded_album: Array = []

func _init() -> void:
	#Set to 1% volume so ears don't get blasted
	volume_linear = 0.01

#For use in settings menu
func set_music_volume(volume_pct: float) -> void:
	volume_linear = volume_pct

func play_track(track_url: String) -> void:
	loaded_track = track_url
	
	var track = load(track_url)
	stream = track
	play()

func play_track_from_album(album: Array, idx: int, rando: bool = false) -> void:
	if idx <= (len(album) - 1):
		randomize_track = rando
		var track_url = album[idx]
		play_track(track_url)
		loaded_album = album
	else:
		print(
			"\n*** MusicManager play_track_from_album() call ***",
			"\n\tInvalid Album Index: ", idx
		)

func play_random_track_from_album(album: Array) -> void:
	var rando = randi_range(0, (len(album) - 1))
	print("Random Track Selected: ", album[rando])
	play_track_from_album(album, rando, true)

func stop_track() -> void:
	stop()

func _on_finished() -> void:
	#print("Music Ended")
	if is_loop:
		if !loaded_album.is_empty() and randomize_track:
			print("Loaded album: ", loaded_album)
			play_random_track_from_album(loaded_album)
		elif loaded_track != "":
			print("Loaded track: ", loaded_track)
			play_track(loaded_track)
		else:
			print(
				"\n*** MusicManager _on_finished() call ***",
				"\n\tThere is no loaded track or album!"
			)
