class_name Medic
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 135
	max_moves = 2
	dmg = 0
	atk_range = 3
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/MEDIC_ICON.png")
	
	troop_type = "Medic"
	attack_types = "Ubercharge, Heal"
	extra_info = "Ubercharge does X" \
	+ "Heal does Y"

func ubercharge():
	pass

func heal():
	pass
