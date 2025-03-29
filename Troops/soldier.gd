extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 180
	max_moves = 2
	dmg = 18
	atk_range = 6
	max_troops_hit = 4
	icon = preload("res://Assets/SOLDIER_ICON.png")

func reload():
	pass

func splash_dmg():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
