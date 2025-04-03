class_name Unit
extends UnitLogic

#Turn Skipping/Prevention
var check_next_tick: bool = false
var steadfast: bool = false
var skip_turn: bool = false
var turns_to_skip: int = 0

#Coordinate Management
var turnStartCoord: Vector2i = Vector2i.ZERO
var turnPreviousCoord: Vector2i = Vector2i.ZERO
var turnCurrentCoord: Vector2i = Vector2i.ZERO
var turnEndCoord: Vector2i = Vector2i(-1, -1)

#
func _ready() -> void:
	super()
	var startCoord = tileMap.local_to_map(coll.global_position)


#This is where troops move and attack
func _turn_in_progress():
	turnCurrentCoord = tileMap.local_to_map(coll.global_position)
	
	##Logic for 2+ troops on one tile here?
	#Whichever troop gets to the tile first during the tick gets priority;
	#If both troops arrive at the same time, set skip_turn to true;
	#Else the troop that does not have the 'taken' status will have skip_turn set to true
	
	if turnCurrentCoord == turnEndCoord:
		if steadfast == false and skip_turn == false:
			check_next_tick = true
	
	if !movePath.is_empty():
		if turnEndCoord != movePath[-1]:
			turnEndCoord = movePath[-1]
			print("Update Turn End Coord")
	
	if turnCurrentCoord == turnPreviousCoord and (steadfast == false or skip_turn == false):
		pass
	else:
		print("Current Tile Coordinate: ", turnCurrentCoord)
		print("Previous Tile Coordinate: ", turnCurrentCoord)
		turnPreviousCoord = turnCurrentCoord

func _check_for_next_tick():
	if check_next_tick == true and steadfast == false:
		check_next_tick = false
		steadfast = true
		print("Troop is Steadfast")
	elif steadfast == true:
		check_next_tick = false

func reset() -> void:
	turnStartCoord = tileMap.local_to_map(coll.global_position)
	turnEndCoord = Vector2i(-1, -1)
	steadfast = false
	print(turnStartCoord)
