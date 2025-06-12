class_name Tile
extends TextureRect
#NOTE: This is to be used to hold data about troops and such

signal _troop_entered(id, unit_id)
signal _troop_exited(id, unit_id)

var traversable: bool = true
var mouse_hover: bool = false
var held_unit: Unit

var id = self

func _spawn_troop(in_troop: TroopData.NAME, is_friendly: bool = false) -> void:
	held_unit = UnitData.unit.instantiate()
	held_unit.friendly = is_friendly
	held_unit.position -= Vector2(0, held_unit.size.y)/4
	add_child(held_unit)
	held_unit.update_troop(in_troop)
	troop_entered()

func troop_entered() -> void:
	#Check if 2 troops on same tile. Traversible should only be set after a troop is on a tile for at least 1 turn
	#If 2 troops enter the same tile within the same turn, do rock paper scissors with weight.
	#Only time when 2 troops enter a tile and it STAYS traversible, is when there is a RPS tie
	#In this case, both troops are knocked back 1 tile from whence they moved from, and lose their queued actions
	
	_troop_entered.emit(id, held_unit)
	print("!!! Troop Entered Tile !!!")
	print("Tile Name: ", id.name, "Tile Ref: ", id)
	print("Unit Name: ", held_unit.name, "Held Unit Ref: ", held_unit)
	traversable = false

func troop_exited() -> void:
	_troop_exited.emit(id, held_unit)
	print("!!! Troop Exited Tile !!!")
	print("Tile Name: ", id.name, "Tile Ref: ", id)
	print("Unit Name: ", held_unit.name, "Held Unit Ref: ", held_unit)
	print("Tile is now traversible!")
	held_unit = null
	traversable = true

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if traversable:
		if data == null:
			print("Null input for troop deployment")
			return false
		
		#print(data, " Len: ", len(data))
		if data is Array and len(data) == 2:
			if data[1] is TroopData.NAME and data[1] != null:
				return true
	
	print("Invalid input for troop deployment")
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	#This should only happen once per portrait
		if data is Array:
			if len(data) == 2:
				if data[0] is TroopPortrait and data[1] is TroopData.NAME:
					if data[0] != null and data[1] != null:
						data[0].draggable = false
						_spawn_troop(data[1], true)

##Test with right click
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		#if mouse_hover:
			#if traversable:
				#print("This is tested from tile.gd, and needs to be removed when there is an actual system in place")
				#spawn_troop()
			#else:
				#print(name, " is not traversable")

#func _on_mouse_entered() -> void:
	#print("Mouse entered the tile ", name)
	#if !mouse_hover:
		#mouse_hover = true
#
#func _on_mouse_exited() -> void:
	#if mouse_hover:
		#mouse_hover = false
