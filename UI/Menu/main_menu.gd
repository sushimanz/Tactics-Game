extends Control

signal noray_connected

@onready var multi_id 
@onready var oid_lbl = $OIDText
@onready var oid_input = $LineEdit
@onready var musicManager = $MusicManager

@onready var buttons := [
	$Buttons/StartButton,
	$Buttons/HostButton,
	$Buttons/JoinButton,
	$Buttons/SettingsButton,
	$Buttons/ExitButton,
	$Buttons/CopyButton
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	musicManager.play_track(musicManager.intro[0])
	
	#await  Multiplayer.noray_connected
	#oid_lbl.text = Noray.oid

	for button in buttons: # simple loop to bind the buttons to the functions
		button.connect("mouse_entered", Callable(self, "_on_mouse_enter").bind(button))
		button.connect("mouse_exited", Callable(self, "_on_mouse_exit").bind(button))
		button.connect("pressed", Callable(self, "_on_mouse_press").bind(button))

func _on_mouse_enter(button):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(button, "scale", Vector2(1.2, 1.2), 0.5)
	
func _on_mouse_exit(button):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.5)
	
func _on_mouse_press(button):
	var tween = get_tree().create_tween()
	tween.tween_property(button, "scale", Vector2(0.9, 0.9), 0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "rotation_degrees", -5, 0.1)
	tween.parallel().tween_property(button, "modulate", Color(0.8, 0.8, 0.8), 0.1)
	tween.tween_property(button, "scale", Vector2(1.0, 1.0), 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(button, "rotation_degrees", 0, 0.2)
	tween.parallel().tween_property(button, "modulate", Color(1, 1, 1), 0.2)
	
func _on_start_button_pressed() -> void:
	await get_tree().create_timer(0.4).timeout
	
	get_tree().change_scene_to_file("res://Game/Game.tscn")

# Added timeout in all the buttons else the animation won't even display

func _on_settings_button_pressed() -> void:
	await get_tree().create_timer(0.4).timeout
	
	print("settings button pressed")  
	#get_tree().change_scene_to_file()


func _on_exit_button_pressed() -> void:
	await get_tree().create_timer(0.4).timeout
	
	get_tree().quit()


func _on_copy_button_pressed() -> void:
	##Old multiplayer stuff
	#DisplayServer.clipboard_set(Noray.oid)
	pass


func _on_join_button_pressed() -> void:
	await get_tree().create_timer(0.4).timeout
	
	##Old multiplayer stuff
	#Multiplayer.join(oid_input.text)
	
	get_tree().change_scene_to_file("res://Game/Game.tscn")


func _on_host_button_pressed() -> void:
	await get_tree().create_timer(0.4).timeout
	
	##Old multiplayer stuff
	#Multiplayer.host()
	
	get_tree().change_scene_to_file("res://Game/Game.tscn")


func set_next_scene_multiplayer(new_scene, multi: bool = false):
	new_scene.is_multiplayer = multi
