extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 145
	max_moves = 3
	dmg = 16
	atk_range = 5
	max_troops_hit = 2
	icon = preload("res://Assets/CANNON_ICON.png")

func build():
	pass
