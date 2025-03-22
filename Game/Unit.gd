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
var movePath: Array = []
var tarLoc: Vector2

func _ready() -> void:
	tileMap = get_parent()
	global_position += Vector2.ONE * 125
	set_multiplayer_authority(name.to_int())
	
	coll.mouse_entered.connect(Mouse_In.bind(true))
	coll.mouse_exited.connect(Mouse_In.bind(false))
	pass

func Mouse_In(State:bool) -> void:
	
	
	Mouse_On_Top = State
	#print(Mouse_On_Top)
	pass




func _process(delta: float) -> void:
	#print(is_multiplayer_authority())
	if is_multiplayer_authority():
		if grabbed and Mouse_On_Top:
			coll.global_position = get_global_mouse_position()
			
			#print(tileMap.get_cell_tile_data(tileMap.local_to_map(global_position)))
			#print(tileMap.local_to_map(global_position))
			var currCoord = tileMap.local_to_map(coll.global_position)
			if !movePath.has(currCoord):
				path.add_point(tileMap.map_to_local(currCoord) - Vector2(125,125))
				movePath.append(currCoord)
				print(movePath)
		
		sprite.global_position = sprite.global_position.lerp(coll.global_position, 0.1)
	
	
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
			if !movePath.is_empty():
				coll.global_position = tileMap.map_to_local(movePath[0])
