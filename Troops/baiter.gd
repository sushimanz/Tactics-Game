class_name Baiter
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 130
	max_moves = 2
	max_attacks = 1
	dmg = 11
	atk_range = 6
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/BAITER_ICON.png")
	
	troop_type = "Baiter"
	attack_types = "Melee, Anchor Pull"
	extra_info = "Anchor Pull does X"

func anchor_pull():
	pass
