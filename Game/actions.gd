class_name Actions
extends Node

func attack(atk_pos: Vector2i, atk_size: int = 1, dmg_falloff_per_tile_pct: float = 1.0):
	#Attack originates from attack position
	#For something like a ranged attack like an arrow, might be different
	#This should work fine for instant or near instant attacks
	
	#Attack size means how big the area is (+ and -, for x and y). 1 = 1x1, 2 = 3x3, 3 = 5x5, ...
	
	#Damage falloff per tile in percent means for each tile out, reduce damage by this much.
	#1.0 means no falloff, 0.5 means 50% falloff 
	#(size >= 1) 10 damage at center, 
	#(size >= 2) 5 damage outer area, 
	#(size >= 3) 2.5 damage outer outer area, and so on
	
	if atk_size < 1:
		atk_size = 1
		print_debug(
			"\n\tCurrent attack size invalid!",
			"\n\tMake sure the attack size is not less than 1!"
		)
	
	if atk_size > 1:
		#Calculate damage for surrounding tiles using attack size
		pass
	
	pass

func move(move_pos: Vector2i):
	pass
