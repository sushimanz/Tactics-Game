extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 100
	max_moves = 2
	dmg = 8
	atk_range = 6
	max_troops_hit = 1
	icon = preload("res://Assets/SPY_ICON.png")

func invis():
	pass

func stab():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
