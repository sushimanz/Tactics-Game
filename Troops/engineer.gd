class_name Engineer
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 200
	max_moves = 2
	max_attacks = 1
	dmg = 18
	atk_range = 0
	max_troops_hit = 2
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/ENGINEER_ICON.png")
	
	troop_type = "Engineer"
	attack_types = "Melee"
	extra_info = "None"
