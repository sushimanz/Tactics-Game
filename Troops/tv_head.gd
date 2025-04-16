class_name TVHead
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	max_health = 125
	max_moves = 2
	max_attacks = 1
	dmg = 14
	atk_range = 5
	max_troops_hit = 9
	
	reinforcements = 5
	reinforce_turns = 1
	
	icon = preload("res://Assets/Icons/TVHEAD_ICON.png")
	
	troop_type = "TV Head"
	attack_types = "Stun, Recharge, Kamikaze"
	extra_info = "Stun does X" \
	+ "Recharge does Y" \
	+ "Kamikaze does Z"

func stun():
	pass

func recharge():
	pass

func kamikaze():
	pass
