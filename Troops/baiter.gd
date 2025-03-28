extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 130
	max_moves = 2
	dmg = 11
	atk_range = 6
	max_troops_hit = 1

func anchor_pull():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
