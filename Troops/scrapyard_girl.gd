class_name ScrapyardGirl
extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 130
	max_moves = 2
	dmg = 11
	atk_range = 0
	max_troops_hit = 1
	
	lives = 5
	respawn_turns = 1
	
	icon = preload("res://Assets/SCRAPYARD_GIRL_ICON.png")
	
	troop_type = "Scrapyard Girl"
	attack_types = "Melee, Build"
	extra_info = "Can build units"
