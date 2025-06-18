class_name Tile
extends TextureRect
##Tile. This is what the grid is made up of, and should be the measure of troop movement and locations in which attacks originate.

signal _mouse_entered(grid_position: Vector2i)
signal _spawn_troop(grid_position: Vector2i, unit_name: TroopData.NAME, is_friendly: bool)
signal _troop_passed(grid_position: Vector2i)

var traversable: bool = true
var mouse_hover: bool = false
var held_unit: Unit

var grid_position: Vector2i

func troop_entered(incoming_unit) -> void:
	#Check if 2 troops on same tile. Traversible should only be set after a troop is on a tile for at least 1 turn
	#If 2 troops enter the same tile within the same turn, do rock paper scissors with weight.
	#Only time when 2 troops enter a tile and it STAYS traversible, is when there is a RPS tie
	#In this case, both troops are knocked back 1 tile from whence they moved from, and lose their queued actions
	
	if held_unit == null:
		held_unit = incoming_unit
		held_unit.grid_position = grid_position
		traversable = false
		_troop_passed.emit(grid_position)
		print("!!! Troop Entered Tile !!!")
		print("Tile Ref: ", self, "Tile Grid Position: ", grid_position)
		print("Unit Name: ", held_unit.name, "Held Unit Ref: ", held_unit)
	elif !held_unit.friendly:
		#Tile occupied by enemy unit
		#Heavy(0) Medium(1) Light(2)
		#Rock Paper Scissors
		var difference = abs(incoming_unit.troop.troop_weight - held_unit.troop.troop_weight)
		
		if difference == 0:
			#Tie
			print(incoming_unit.name, " and ", held_unit.name, " are both knocked away")
			pass
		elif (difference == 1 and incoming_unit.troop.troop_weight > held_unit.troop.troop_weight) or (difference == 2 and incoming_unit.troop.troop_weight < held_unit.troop.troop_weight):
			#Incoming unit wins
			print(incoming_unit.name, " pushes ", held_unit.name, " out of the way")
			pass
		else:
			#Incoming unit loses
			print(held_unit.name, " pushes ", incoming_unit.name, " out of the way")
			pass
	else:
		#Tile occupied by friendly unit, or otherwise non-hostile object
		pass

func troop_exited() -> void:
	#This should call no matter what when a troop leaves
	held_unit = null
	traversable = true
	_troop_passed.emit(grid_position)
	print("!!! Troop Exited Tile !!!")
	print("Tile Ref: ", self, "Tile Grid Position: ", grid_position)
	print("Unit Name: ", held_unit.name, "Held Unit Ref: ", held_unit)
	print("-- Tile is now traversible! --")

#Need to make new class/script for this, probably
enum CHECKTYPE {ATTACK, MOVE, DEPLOY}
var check: CHECKTYPE

func unit_attack_check(data: Variant = null) -> bool:
	#On a drag move
	if data is Unit:
		#print("Can attack with this troop")
		return true
	
	#TODO On a click move
	
	return false

func unit_move_check(data: Variant) -> bool:
	#On a drag move
	if data is Unit:
		#print("Can move this troop")
		return true
	
	#TODO On a click move
	
	return false

func unit_deployment_check(data: Variant) -> bool:
	#On a drag deployment
	if data is TroopPortrait:
		#print("Can deploy this troop")
		return true
	
	#TODO On a click deployment
	
	return false

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if traversable:
		if data == null:
			print("Null input for troop deployment")
			return false
		elif GameloopData.gamestate == GameloopData.GAMESTATE.ROUND:
			if GameloopData.roundstate == GameloopData.ROUNDSTATE.PLANNING:
				#if unit_attack_check():
					#return true
				if unit_move_check(data):
					return true
		elif GameloopData.gamestate == GameloopData.GAMESTATE.DEPLOY:
			if unit_deployment_check(data):
				return true
	
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is TroopPortrait:
		data.draggable = false
		_spawn_troop.emit(grid_position, data.troop_name, true)
	elif data is Unit:
		pass

func _input(event: InputEvent) -> void:
	if mouse_hover:
		if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
			print("Tile Name: ", name, "Tile Ref: ", self)
			var s: String = ""
			if !traversable:
				s = "not"
			print("Tile is ", s, " travesable")
			if held_unit:
				print("Unit Name: ", held_unit.name, "Held Unit Ref: ", held_unit)
			else:
				print("There is no unit here!")
		
		#if event is InputEventMouseMotion:

func _on_mouse_entered() -> void:
	_mouse_entered.emit(grid_position)
	#print("Mouse ENTERED the tile at ", grid_position)
	mouse_hover = true

func _on_mouse_exited() -> void:
	#print("Mouse EXITED the tile at ", grid_position)
	mouse_hover = false
