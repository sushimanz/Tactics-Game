extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 300
	max_moves = 2
	dmg = 26
	atk_range = 5
	max_troops_hit = 1

func dmg_drop_off ():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
