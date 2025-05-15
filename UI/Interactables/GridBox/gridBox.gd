class_name GridBox
extends TextureRect
#NOTE: This is to be used to hold data about troops and such

var occupied: bool = false
@export var unit: PackedScene = preload("res://Game/Unit/Unit.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		add_child(unit.instantiate())
