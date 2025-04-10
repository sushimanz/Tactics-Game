class_name Baiter
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 130
	max_moves = 2
	dmg = 11
	atk_range = 6
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/BAITER_ICON.png")
	
	troop_type = "Baiter"
	attack_types = "Melee, Anchor Pull"
	extra_info = "Anchor Pull does X"

func anchor_pull():
	pass
