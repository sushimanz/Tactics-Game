class_name Spy
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 100
	max_moves = 2
	max_attacks = 1
	dmg = 8
	atk_range = 6
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/SPY_ICON.png")
	
	troop_type = "Spy"
	attack_types = "Melee, Invisible"
	extra_info = "Invisible does X"

func invis():
	pass

func stab():
	pass
