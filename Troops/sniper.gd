class_name Sniper
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 117
	max_moves = 2
	dmg = 12
	atk_range = 8
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/SNIPER_ICON.png")
	
	troop_type = "Sniper"
	attack_types = "Melee, Ranged"
	extra_info = "None"

func ready_shoot():
	pass

func headshot():
	pass
