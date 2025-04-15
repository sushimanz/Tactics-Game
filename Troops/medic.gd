class_name Medic
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 135
	max_moves = 2
	max_attacks = 1
	dmg = 0
	atk_range = 3
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/MEDIC_ICON.png")
	
	troop_type = "Medic"
	attack_types = "Ubercharge, Heal"
	extra_info = "Ubercharge does X" \
	+ "Heal does Y"

func ubercharge():
	pass

func heal():
	pass
