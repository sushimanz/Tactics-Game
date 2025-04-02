extends Troop

# Called when the node enters the scene tree for the first time.
func _init():
	health = 1
	max_moves = 1
	dmg = 1
	atk_range = 1
	max_troops_hit = 1
	icon = preload("res://Assets/SCRAPYARD_GIRL_ICON.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
