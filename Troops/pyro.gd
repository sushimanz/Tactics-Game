extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 140
	max_moves = 2
	dmg = 16
	atk_range = 4
	max_troops_hit = 1
	icon = preload("res://Assets/PYRO_ICON.png")

func set_on_fire():
	pass

func put_fire_out():
	pass

func immune_fire():
	pass

func air_blast():
	pass
