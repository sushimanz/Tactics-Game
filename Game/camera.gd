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
@export var move_limit_up: float = -480
@export var move_limit_down: float = 480
@export var move_limit_left: float = -270
@export var move_limit_right: float = 270

func _init() -> void:
	zoom_min = Vector2(int_zoom_min, int_zoom_min)
	zoom_max = Vector2(int_zoom_max, int_zoom_max)
	zoom_default = Vector2(int_zoom_default, int_zoom_default)
	
	spawn_pos = position
	zoom = zoom_default

func _input(event: InputEvent) -> void:
	#Should make this a smoother camera at some point
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_F1:
			position = spawn_pos
		if event.keycode == KEY_W or event.keycode == KEY_A or event.keycode == KEY_S or event.keycode == KEY_D:
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
	
	if event is InputEventMouseButton and event.is_pressed():
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
