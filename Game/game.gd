extends Control

@onready var grid = $Grid

func _init() -> void:
	pass

func _ready() -> void:
	pass

func _start_game(h: int = PathData.res_grid.cur_height, w: int = PathData.res_grid.cur_width) -> void:
	var tiles = grid.get_children()
	if not tiles.is_empty():
		for tile in tiles:
			tile.queue_free()
	
	grid.set_grid(h, w)
