class_name Soldier
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 180
	max_moves = 2
	dmg = 18
	atk_range = 6
	max_troops_hit = 4
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/SOLDIER_ICON.png")
	
	troop_type = "Soldier"
	attack_types = "Melee"
	extra_info = "Gotta update"

func reload():
	pass

func splash_dmg():
	pass
