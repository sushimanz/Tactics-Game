class_name GridBox
extends TextureRect
#NOTE: This is to be used to hold data about troops and such

var occupied: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if not occupied:
			add_child(UnitData.unit.instantiate())
			occupied = true
		else:
			print(name, " is occupied")

func _on_mouse_entered() -> void:
	print("Mouse entered ", name)
