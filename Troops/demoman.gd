class_name Demoman
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 150
	max_moves = 2
	max_attacks = 1
	dmg = 21
	atk_range = 4
	max_troops_hit = 3
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/DEMOMAN_ICON.png")
	
	troop_type = "Demoman"
	attack_types = "Ranged"
	extra_info = "Area explosion damage"

func splash_damage():
	pass
