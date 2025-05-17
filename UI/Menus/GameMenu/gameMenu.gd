extends Menu

func _on_back_button_pressed() -> void:
	_go_back()

func _on_next_button_pressed() -> void:
	_update_mainstate(Main.MAINSTATE.START_GAME)

@onready var height = $OtherSettings/Height
@onready var width = $OtherSettings/Width

func _ready() -> void:
	height.min_int = PathData.res_grid.min_height
	height.max_int = PathData.res_grid.max_height
	width.min_int = PathData.res_grid.min_width
	width.max_int = PathData.res_grid.max_width

func _on_height_new_valid_input(in_valid: int) -> void:
	PathData.res_grid.cur_height = in_valid

func _on_width_new_valid_input(in_valid: int) -> void:
	PathData.res_grid.cur_width = in_valid
