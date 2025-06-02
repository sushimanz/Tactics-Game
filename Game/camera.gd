extends Camera2D

var zoom_vec = Vector2(0.05, 0.05)
@export var int_zoom_min: float = 0.35
@export var int_zoom_max: float = 1.0
@export var int_zoom_default: float = 0.5
var zoom_min: Vector2
var zoom_max: Vector2
var zoom_default: Vector2

var spawn_pos: Vector2
@export var pos_shift: int = 10

##Thses need to be updated based on grid size
@export var move_limit_up: float = -480
@export var move_limit_down: float = 480
@export var move_limit_left: float = -270
@export var move_limit_right: float = 270

var pan_btn_held: bool = false
var init_pos: Vector2
var cur_pos: Vector2
var grab_pos: Vector2

func _init() -> void:
	zoom_min = Vector2(int_zoom_min, int_zoom_min)
	zoom_max = Vector2(int_zoom_max, int_zoom_max)
	zoom_default = Vector2(int_zoom_default, int_zoom_default)
	
	spawn_pos = position
	zoom = zoom_default

func _physics_process(_delta: float) -> void:
	if pan_btn_held:
		mouse_pan()

func _input(event: InputEvent) -> void:
	if visible:
		#Should make this a smoother camera at some point
		if event is InputEventKey and event.is_pressed():
			if event.keycode == KEY_F1:
				position = spawn_pos
			
			var to_pos = position
			if event.keycode == KEY_W:
				to_pos.y += -pos_shift
			if event.keycode == KEY_S:
				to_pos.y += pos_shift
			if event.keycode == KEY_A:
				to_pos.x += -pos_shift
			if event.keycode == KEY_D:
				to_pos.x += pos_shift
			
			if position != to_pos:
				position = to_pos
			
			print("Camera Position: ", position)
		
		if event is InputEventMouseButton: 
			if event.is_pressed():
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					if zoom < zoom_max:
						var to_zoom = zoom + zoom_vec
						if to_zoom > zoom_max:
							to_zoom = zoom_max
						zoom = to_zoom
					print("Camera Zoom: ", zoom)
				
				if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					if zoom > zoom_min:
						var to_zoom = zoom - zoom_vec
						if to_zoom < zoom_min:
							to_zoom = zoom_min
						zoom = to_zoom
					print("Camera Zoom: ", zoom)
				
				if event.button_index == MOUSE_BUTTON_LEFT:
					if not pan_btn_held:
						pan_btn_held = true
						grab_pos = position
						init_pos = get_local_mouse_position()
			
			else:
				if pan_btn_held:
					pan_btn_held = false

func mouse_pan() -> void:
	if visible:
		cur_pos = get_local_mouse_position()
		var pos_offset = (init_pos - cur_pos)
		#print("Offset: ", pos_offset, "\tInit: ", init_pos, "\tCur: ", cur_pos)
		position = grab_pos + pos_offset
