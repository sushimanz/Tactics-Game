extends CharacterBody2D


@export var Tile_Map:A_Star_2D
@export var Speed:float = 1
var Current_Path:Array[Vector2i]



var Selected:bool
var Mouse_On_Top:bool

func _ready() -> void:
	
	mouse_entered.connect(Mouse_In.bind(true))
	mouse_exited.connect(Mouse_In.bind(false))
	pass

func Mouse_In(State:bool) -> void:
	
	
	Mouse_On_Top = State
	print(Mouse_On_Top)
	pass








func _process(delta: float) -> void:
	if Current_Path.is_empty():
		return
	else:
		var Target_Pos:Vector2 = Tile_Map.map_to_local(Current_Path.front())
		global_position = global_position.move_toward(Target_Pos,Speed * delta)
		
		if global_position == Target_Pos:
			Current_Path.pop_front()
		
		if Current_Path.is_empty():
			#Arrived
			Tile_Map.A_Star.set_point_solid(Tile_Map.local_to_map(global_position))
	
	pass


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("LClick"):
		
		if Mouse_On_Top:
			Selected = true
			return
		
		if Selected:
			Tile_Map.A_Star.set_point_solid(Tile_Map.local_to_map(global_position),false)
			var Click_Pos:Vector2 = get_global_mouse_position()
			if Tile_Map.Is_Pos_Avilbel(Click_Pos):
				Current_Path = Tile_Map.A_Star.get_id_path(
					Tile_Map.local_to_map(global_position),
					Tile_Map.local_to_map(Click_Pos)
				).slice(1)
				pass
			Selected = false
		
