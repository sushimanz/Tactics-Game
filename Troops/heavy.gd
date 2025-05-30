class_name Heavy
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 300
	max_moves = 2
	max_attacks = 1
	dmg = 26
	atk_range = 5
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/HEAVY_ICON.png")
	
	troop_type = "Heavy"
	attack_types = "Melee, Ranged"
	extra_info = "Has damage dropoff"

func dmg_drop_off ():
	pass
