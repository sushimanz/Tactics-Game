class_name Engineer
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 200
	max_moves = 2
	dmg = 18
	atk_range = 0
	max_troops_hit = 2
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/ENGINEER_ICON.png")
	
	troop_type = "Engineer"
	attack_types = "Melee"
	extra_info = "None"
