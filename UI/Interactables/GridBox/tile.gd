class_name Tile
extends TextureRect
#NOTE: This is to be used to hold data about troops and such

signal troop_entered(name, unit)

var traversable: bool = true
var mouse_hover: bool = false
var held_unit: Unit

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		if mouse_hover:
			if traversable:
				print("This is tested from gridBox.gd, and needs to be removed when there is an actual system in place")
				held_unit = UnitData.unit.instantiate()
				held_unit.position -= Vector2(0, held_unit.size.y)/4
				add_child(held_unit)
				troop_entered.emit(name, held_unit)
				traversable = false
			else:
				print(name, " is not traversable")
		

func _on_mouse_entered() -> void:
	print("Mouse entered the tile ", name)
	if !mouse_hover:
		mouse_hover = true

func _on_mouse_exited() -> void:
	if mouse_hover:
		mouse_hover = false
