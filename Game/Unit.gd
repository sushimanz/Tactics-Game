extends Node2D


var tileMap : TileMapLayer
@export var Speed: float = 1
@onready var path: Line2D = $Path
@onready var coll: Area2D = $Collision
@onready var sprite: Sprite2D = $Sprite2D
var Current_Path:Array[Vector2i]

var Selected:bool
var Mouse_On_Top:bool
var grabbed: bool = false
var movePath: Array = [Vector2.ZERO]
@export var movePathBounds: Vector2 = Vector2(13, 7)
var tarLoc: Vector2
var skewV: Vector2 = Vector2.ZERO
var playerID: int = 0
var dist_moved: int = 0

#
enum GAMESTATE {INIT, START, PLAN, ACTIVE, END}
var game_state: GAMESTATE = GAMESTATE.INIT
var turnStartCoord: Vector2 = Vector2.ZERO

#Troop values
@export var in_troop_type: String = "troopname"
@export var health: int = 100
@export var max_moves: int = 12
@export var dmg: int = 50
@export var atk_range: int = 10
@export var max_troops_hit: int = 5
@export var icon: CompressedTexture2D = preload("res://Assets/KNIGHT_ICON.png")

func _ready() -> void:
	if Multiplayer.is_host:
		playerID = 1
	else:
		playerID = 2
	
	tileMap = get_parent()
	global_position += Vector2.ONE * 125
	set_multiplayer_authority(name.to_int())
	
	
	coll.mouse_entered.connect(Mouse_In.bind(true))
	coll.mouse_exited.connect(Mouse_In.bind(false))
	
	var startCoord = tileMap.local_to_map(coll.global_position)

func set_troop_values(troop: Troop) -> void:
	#print("Troop initialization started!")
	if troop:
		if troop is Troop:
			health = troop.health
			max_moves = troop.max_moves
			dmg = troop.dmg
			atk_range = troop.atk_range
			max_troops_hit = troop.max_troops_hit
			icon = troop.icon
			sprite.texture = icon
		
	else:
		#Currently put in crazy values, get rid of this testing feature if there seem to be no to little bugs
		health = 999
		max_moves = 999
		dmg = 100
		atk_range = 99
		max_troops_hit = 99
		print("Troop initialization failed! Input: ", troop)
	
	#Reset path on troop initialization
	path.clear_points()
	movePath.clear()

func Mouse_In(State:bool) -> void:
	
	Mouse_On_Top = State
	#print(Mouse_On_Top)
	pass

#Do when a turn just started, mostly just to update troop starting location
func _on_turn_started():
	turnStartCoord = tileMap.local_to_map(coll.global_position)

func _planning_phase():
	edit_path()

func _turn_in_progress():
	#This is where troops move and attack
	pass

func _on_turn_ended():
	#Not sure if this is really needed but good to keep in the loop for visual
	pass

func _process(delta: float) -> void:
	match game_state:
		#Do ONLY at the start of the game, mostly for the troop selector and deployment at the start
		GAMESTATE.INIT:
			game_state = GAMESTATE.START
		
		#Do when a turn just started, mostly just to update troop starting location
		GAMESTATE.START:
			_on_turn_started()
			game_state = GAMESTATE.PLAN
		
		#Do during the planning phase, there is player interaction here
		GAMESTATE.PLAN:
			_planning_phase()
			
			#Make an if statement to check the time; if timer runs out, then change gamestate
			game_state = GAMESTATE.START
		
		#Do when a turn is in progress, there is NO player interaction here
		GAMESTATE.ACTIVE:
			_turn_in_progress()
			
			#Make an if statement to check if all turns have been completed, then change gamestate
			game_state = GAMESTATE.END
		
		GAMESTATE.END:
			_on_turn_ended()
			game_state = GAMESTATE.START
		
		_:
			print("No Gamestate, there is an issue here! Resetting game...")
			game_state = GAMESTATE.INIT
		

func edit_path():
	if is_multiplayer_authority():
		if grabbed and Mouse_On_Top:
			var currCoord = tileMap.local_to_map(coll.global_position)
			var tileCenter = tileMap.map_to_local(currCoord) - Vector2(125,125)
			var mospos = get_global_mouse_position()
			coll.global_position = mospos
			
			#print(tileMap.get_cell_tile_data(tileMap.local_to_map(global_position)))
			#print(tileMap.local_to_map(global_position))
			
			#Keep the pathing within the map bounds
			if (currCoord.x >= 0 and currCoord.y >= 0) and (currCoord.x < movePathBounds.x and currCoord.y < movePathBounds.y):
				#Initialize distance moved from start position
				if movePath.is_empty():
					dist_moved = 0
				
				#Update the pathing
				if !movePath.has(currCoord) and (movePath.is_empty() or movePath[movePath.size()-1].distance_to(currCoord) == 1):
					if dist_moved < max_moves:
						if !movePath.is_empty():
							dist_moved += 1
						path.add_point(tileCenter)
						movePath.append(currCoord)
						#print(movePath)
						print("Path Distance: ",dist_moved)
					else:
						#Maybe add some visual to know the troop is over the path range
						#print("Over Troop Range Logic!")
						pass
				
				#Remove pathing if backtracking
				if movePath.size() >= 2 and currCoord == movePath[movePath.size()-2]:
					path.remove_point(movePath.size()-1)
					movePath.remove_at(movePath.size()-1)
					dist_moved -= 1
					print("Path Distance: ",dist_moved)
					
				skewV = lerp(skewV, Input.get_last_mouse_velocity()/25, 0.1).clamp(Vector2.ONE * -25, Vector2.ONE * 25)
		
		#Set skewV to 0 if not grabbed to avoid visual issues
		else:
			skewV = Vector2.ZERO
		sprite.global_position = sprite.global_position.lerp(coll.global_position, 0.1)
	sprite.material.set_shader_parameter('y_rot', skewV.x)
	sprite.material.set_shader_parameter('x_rot', -skewV.y)
	
	## old AStar
	#if Current_Path.is_empty():
		#return
	#else:
		#var Target_Pos:Vector2 = Tile_Map.map_to_local(Current_Path.front())
		#global_position = global_position.move_toward(Target_Pos,Speed * delta)
		#
		#if global_position == Target_Pos:
			#Current_Path.pop_front()
		#
		#if Current_Path.is_empty():
			##Arrived
			#Tile_Map.A_Star.set_point_solid(Tile_Map.local_to_map(global_position))


func _input(_event: InputEvent) -> void:
	if Mouse_On_Top:
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

func tickUpdate(tick) -> bool:
	if !movePath.is_empty():
		if tick >= movePath.size()-1:
			return false
		var nextPos = tileMap.map_to_local(movePath[tick+1]) - Vector2(125,125)
		var tween = get_tree().create_tween().parallel()
		tween.tween_property(coll, "position", nextPos, 0.1)
		#tween.tween_property(sprite, "position", nextPos, 1)
		return true
	return false
