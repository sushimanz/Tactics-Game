extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 150
	max_moves = 2
	dmg = 21
	atk_range = 4
	max_troops_hit = 3
	icon = preload("res://Assets/DEMOMAN_ICON.png")

func splash_damage():
	pass
