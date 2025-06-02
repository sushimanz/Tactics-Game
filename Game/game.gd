extends Control

signal _update_mainstate(next_state: Main.MAINSTATE)

@onready var grid = $Grid
@onready var portrait_ui = $PortraitUI

func _init() -> void:
	pass

func _ready() -> void:
	pass

func _init_game(h: int = ResData.grid.cur_height, w: int = ResData.grid.cur_width) -> void:
	grid.set_grid(h, w)

func _start_game() -> void:
	print("Squad: ", SquadData.friendly_troops)
	portrait_ui.set_portraits()

func _end_game() -> void:
	var tiles = grid.get_children()
	for tile in tiles:
		tile.queue_free()
	
	#FIXME Make sure to change this, it is a temporary workaround
	update_mainstate(Main.MAINSTATE.ENTER_TITLE)

#Can figure out how to make this better later
func update_mainstate(next_mainstate: Main.MAINSTATE):
	_update_mainstate.emit(next_mainstate)
