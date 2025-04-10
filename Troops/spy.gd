class_name Spy
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 100
	max_moves = 2
	dmg = 8
	atk_range = 6
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/SPY_ICON.png")
	
	troop_type = "Spy"
	attack_types = "Melee, Invisible"
	extra_info = "Invisible does X"

func invis():
	pass

func stab():
	pass
