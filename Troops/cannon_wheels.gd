class_name CannonWheels
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 145
	max_moves = 3
	max_attacks = 1
	dmg = 16
	atk_range = 5
	max_troops_hit = 2
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/CANNON_ICON.png")
	
	troop_type = "Cannon Wheels"
	attack_types = "Build"
	extra_info = "Can build things I guess?"

func build():
	pass
