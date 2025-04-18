class_name Sniper
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 117
	max_moves = 2
	max_attacks = 1
	dmg = 12
	atk_range = 8
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/SNIPER_ICON.png")
	
	troop_type = "Sniper"
	attack_types = "Melee, Ranged"
	extra_info = "None"

func ready_shoot():
	pass

func headshot():
	pass
