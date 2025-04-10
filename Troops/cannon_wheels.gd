class_name CannonWheels
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 145
	max_moves = 3
	dmg = 16
	atk_range = 5
	max_troops_hit = 2
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/CANNON_ICON.png")
	
	troop_type = "Cannon Wheels"
	attack_types = "Build"
	extra_info = "Can build things I guess?"

func build():
	pass
