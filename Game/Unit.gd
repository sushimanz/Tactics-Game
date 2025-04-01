class_name Unit
extends UnitLogic

#Start timer (If doing a pre-plan stage before player interaction)
@onready var startTimer = get_parent().get_parent().get_child(2)		#Gotta find a better way to get the planTimer (Or do the logic as part of the game)
@export var start_end_time: int = 2		#Time in seconds
var start_time_left: float = start_end_time
var prev_start_time_left: int

#Plan Timer
@onready var planTimer = get_parent().get_parent().get_child(3)		#Gotta find a better way to get the planTimer (Or do the logic as part of the game)
@export var plan_end_time: int = 8		#Time in seconds
var plan_time_left: float = plan_end_time
var prev_plan_time_left: int

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
	if Multiplayer.is_host:
		playerID = 1
	else:
		playerID = 2
	
	tileMap = get_parent()
	global_position += Vector2.ONE * 125
	set_multiplayer_authority(name.to_int(), true)
	
	coll.mouse_entered.connect(Mouse_In.bind(true))
	coll.mouse_exited.connect(Mouse_In.bind(false))
	
	var startCoord = tileMap.local_to_map(coll.global_position)

func _on_init():
	print("GAMESTATE INITIALIZING")
	startTimer.wait_time = start_end_time
	prev_start_time_left = startTimer.wait_time
	
	planTimer.wait_time = plan_end_time
	prev_plan_time_left = planTimer.wait_time
	
	startTimer.start()

func _pre_planning_phase():
	start_time_left = int(floor(startTimer.time_left))
	if prev_start_time_left > start_time_left:
		print("Pre-Planning Time Left: ", prev_start_time_left)
		prev_start_time_left = start_time_left
		#Updates for every second

#Do when a turn just started, mostly just to update troop starting location
func _on_turn_started():
	turnStartCoord = tileMap.local_to_map(coll.global_position)
	turnEndCoord = Vector2i(-1, -1)
	steadfast = false
	print(turnStartCoord)

#Where planning phase occurs and pathing is created
func _planning_phase():
	plan_time_left = int(floor(planTimer.time_left))
	if prev_plan_time_left > plan_time_left:
		print("Planning Time Left: ", prev_plan_time_left)
		prev_plan_time_left = plan_time_left
		#Updates for every second
	
	if turnPreviousCoord != turnStartCoord:
		turnPreviousCoord = turnStartCoord
	
	edit_path()

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

#Not sure if this is really needed but good to keep in the loop for visual
func _on_turn_ended():
	steadfast = false
	startTimer.start()
	
	print("Troop End Coordinate: ", turnEndCoord)

#Some of this logic should actually go into the gameStateLogic.gd instead, such as the timer
func _process(delta: float) -> void:
	match game_state:
		#Do ONLY at the start of the game, mostly for the troop selector and deployment at the start
		GAMESTATE.INIT:
			_on_init()
			
			game_state = GAMESTATE.START
			print("CHANGE GAMESTATE TO START")
		
		#Do when a turn just started, mostly just to update troop starting location
		GAMESTATE.START:
			if startTimer.time_left <= 0:
				startTimer.stop()
				prev_start_time_left = startTimer.wait_time
				planTimer.start()
				
				_on_turn_started()
				game_state = GAMESTATE.PLAN
				print("CHANGE GAMESTATE TO PLAN")
			else:
				_pre_planning_phase()
		
		#Do during the planning phase, there is player troop interaction here
		GAMESTATE.PLAN:
			if planTimer.time_left <= 0:
				planTimer.stop()
				prev_plan_time_left = planTimer.wait_time
				game_state = GAMESTATE.ACTIVE
				print("CHANGE GAMESTATE TO ACTIVE")
			elif planTimer.time_left > 0 and not skip_turn:
				_planning_phase()
		
		#Do when a turn is in progress, there is NO playert troop interaction here
		GAMESTATE.ACTIVE:
			#Temporary statement since gamestates are currently controlled inside the unit
			if turnCurrentCoord == turnEndCoord:
				game_state = GAMESTATE.END
				print("CHANGE GAMESTATE TO END")
			else:
				_turn_in_progress()
		
		GAMESTATE.END:
			_on_turn_ended()
			
			game_state = GAMESTATE.START
			print("CHANGE GAMESTATE TO START")
		
		_:
			print("No Gamestate, there is an issue here!")
			game_state = GAMESTATE.INIT
			print("INITIALIZE GAMESTATE")

func _input(_event: InputEvent) -> void:
	if Mouse_On_Top and game_state == GAMESTATE.PLAN:
		if _event.is_action_pressed("LClick"):
			print("yo")
			path.clear_points()
			movePath.clear()
			grabbed = true
			
			## old AStar code
			#if Mouse_On_Top:
				#Selected = true
				#return
			#if Selected:
				#Tile_Map.A_Star.set_point_solid(Tile_Map.local_to_map(global_position),false)
				#var Click_Pos:Vector2 = get_global_mouse_position()
				#if Tile_Map.Is_Pos_Avilbel(Click_Pos):
					#Current_Path = Tile_Map.A_Star.get_id_path(
						#Tile_Map.local_to_map(global_position),
						#Tile_Map.local_to_map(Click_Pos)
					#).slice(1)
					#pass
				#Selected = false
		
		if _event.is_action_released("LClick"):
			grabbed = false
			sprite.material.set_shader_parameter('y_rot', 0)
			sprite.material.set_shader_parameter('x_rot', 0)
			if !movePath.is_empty():
				coll.global_position = tileMap.map_to_local(movePath[0])
