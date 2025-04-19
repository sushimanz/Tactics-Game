class_name Soldier
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 180
	max_moves = 2
	max_attacks = 1
	dmg = 18
	atk_range = 6
	max_troops_hit = 4
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/SOLDIER_ICON.png")
	
	troop_type = "Soldier"
	attack_types = "Ranged"
	extra_info = "Splash area damage"

func reload():
	pass

func splash_dmg():
	pass
