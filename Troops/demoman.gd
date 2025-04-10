class_name Demoman
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 150
	max_moves = 2
	dmg = 21
	atk_range = 4
	max_troops_hit = 3
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/DEMOMAN_ICON.png")
	
	troop_type = "Demoman"
	attack_types = "Melee, Explosion thing"
	extra_info = "Idk, gotta update"

func splash_damage():
	pass
