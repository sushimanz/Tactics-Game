class_name Heavy
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 300
	max_moves = 2
	dmg = 26
	atk_range = 5
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/HEAVY_ICON.png")
	
	troop_type = "Heavy"
	attack_types = "Melee"
	extra_info = "Has damage dropoff"

func dmg_drop_off ():
	pass
