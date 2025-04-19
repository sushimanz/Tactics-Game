class_name Archer
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 110
	max_moves = 2
	max_attacks = 1
	dmg = 13
	atk_range = 6
	max_troops_hit = 2
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/ARCHER_ICON.png")
	
	troop_type = "Archer"
	attack_types = "Ranged"
	extra_info = "Ranged attack has knockback"

func knockback():
	pass

func headshot():
	dmg = 30
