extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 105
	max_moves = 3
	dmg = 18
	atk_range = 3
	max_troops_hit = 3
	icon = preload("res://Assets/SCOUT_ICON.png")

func tile_checker():
	var dmg_drop_off = dmg
	dmg_drop_off -= 10
