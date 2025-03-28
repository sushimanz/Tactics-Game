extends Troop

# Called when the node enters the scene tree for the first time.
func _ready():
	health = 300
	moves = 2
	dmg = 26
	range = 5
	max_troops_hit = 1
	
	pass # Replace with function body.
	
func dmg_drop_off ():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
