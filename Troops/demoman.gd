extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 150
	max_moves = 2
	dmg = 21
	atk_range = 4
	max_troops_hit = 3

func splash_damage():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
