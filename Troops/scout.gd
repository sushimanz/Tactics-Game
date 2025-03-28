extends Troop

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 105
	moves = 3
	dmg = 18
	range = 3
	max_troops_hit = 3
	
	pass # Replace with function body.

func tile_checker():
	var dmg_drop_off = dmg
	dmg_drop_off -= 10
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
