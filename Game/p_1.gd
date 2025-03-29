extends Node2D

@export var readyState: bool = false



func _on_button_pressed() -> void:
	print (get_multiplayer_authority())
	if is_multiplayer_authority():
		readyState = true
