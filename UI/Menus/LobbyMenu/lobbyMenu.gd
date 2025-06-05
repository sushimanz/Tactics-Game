extends UI

func _on_back_button_pressed() -> void:
	_go_back()

func _on_next_button_pressed() -> void:
	_update_mainstate(Main.MAINSTATE.START_GAME)

@onready var height = $GridSettings/Height
@onready var width = $GridSettings/Width

func _ready() -> void:
	height.min_int = ResData.grid.min_height
	height.max_int = ResData.grid.max_height
	width.min_int = ResData.grid.min_width
	width.max_int = ResData.grid.max_width

func _on_height_new_valid_input(in_valid: int) -> void:
	ResData.grid.cur_height = in_valid

func _on_width_new_valid_input(in_valid: int) -> void:
	ResData.grid.cur_width = in_valid
