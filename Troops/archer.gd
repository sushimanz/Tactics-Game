extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 110
	max_moves = 2
	dmg = 13
	atk_range = 6
	max_troops_hit = 2

func knockback():
	pass

func headshot():
	var dmg_multi = dmg
	dmg_multi += 17

func _process(delta: float) -> void:
	pass
