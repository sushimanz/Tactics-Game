class_name Pyro
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 140
	max_moves = 2
	max_attacks = 1
	dmg = 16
	atk_range = 4
	max_troops_hit = 1
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/PYRO_ICON.png")
	
	troop_type = "Pyro"
	attack_types = "Set on Fire, Put Fire Out, Immune Fire, Air Blast"
	extra_info = "Set on Fire does X" \
	+ "Put Fire Out does Y" \
	+ "Immune Fire Out does Z" \
	+ "Air Blast does A"

func set_on_fire():
	pass

func put_fire_out():
	pass

func immune_fire():
	pass

func air_blast():
	pass
