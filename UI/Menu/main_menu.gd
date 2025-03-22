extends Control

signal noray_connected

@onready var multi_id 
@onready var oid_lbl = $OIDText
@onready var oid_input = $JoinButton/LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	await  Multiplayer.noray_connected
	oid_lbl.text = Noray.oid


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Game/Game.tscn")


func _on_settings_button_pressed() -> void:
	print("settings button pressed")  
	#get_tree().change_scene_to_file()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_copy_button_pressed() -> void:
	DisplayServer.clipboard_set(Noray.oid)


func _on_join_button_pressed() -> void:
	Multiplayer.join(oid_input.text)
	get_tree().change_scene_to_file("res://Game/Game.tscn")


func _on_host_button_pressed() -> void:
	Multiplayer.host()
	
	get_tree().change_scene_to_file("res://Game/Game.tscn")
