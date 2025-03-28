extends Troop

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 110
	moves = 2
	dmg = 13
	range = 6
	max_troops_hit = 2
	
	
	pass # Replace with function body.

func knockback():
	pass
	
func headshot():
	var dmg_multi = dmg
	dmg_multi += 17
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
