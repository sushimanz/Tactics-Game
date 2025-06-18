class_name Actions
extends Control

enum ACTION {ATTACK, MOVE}
var queued_action: Dictionary[ACTION, Vector2]

var grid_data = ResData.grid
var atk_node: Node

#var attack = Attack.new()
var test_size: int = 1
var test_btn_held: bool = false

func attack(atk_pos: Vector2i, dmg: int = 0, atk_size: int = 1, dmg_falloff_per_tile_pct: float = 100.0):
	if dmg >= 0:
		#do damage to enemy ONLY
		pass
	elif dmg < 0:
		#do negative damage (healing) to friendly ONLY
		pass
	
	atk_pos -= Vector2i(grid_data.grid_size, grid_data.grid_size)/2
	#Attack originates from attack position
	#For something like a ranged attack like an arrow, might be different
	#This should work fine for instant or near instant attacks
	
	#Attack size means how big the area is (+ and -, for x and y). 1 = 1x1, 2 = 3x3, 3 = 5x5, ...
	
	#Damage falloff per tile in percent means for each tile out, reduce damage by this much.
	#100.0 means no falloff, 50.0 means 50% falloff 
	#(size >= 1) 10 damage at center, 
	#(size >= 2) 5 damage outer area, 
	#(size >= 3) 2.5 damage outer outer area, and so on
	
	if dmg_falloff_per_tile_pct > 100.0:
		dmg_falloff_per_tile_pct = 100.0
		print_debug(
			"\n\tCurrent damage falloff invalid!",
			"\n\tMake sure the damage falloff is not more than 100.0!"
		)
	
	if atk_size < 1:
		atk_size = 1
		print_debug(
			"\n\tCurrent attack size invalid!",
			"\n\tMake sure the attack size is not less than 1!"
		)
	var atk_square = (2 * atk_size) - 1
	var atk_offset = atk_size - 1
	atk_node = Control.new()
	atk_node.name = "AttackNode"
	add_child(atk_node)
	
	var test = GridData.tile.instantiate()
	test.position = atk_pos
	test.name = "Attack at (0, 0)"
	atk_node.add_child(test)
	#Calculate damage for surrounding tiles using attack size
	for w in range(atk_square):
		var x_pos_offset = (w - atk_offset) * grid_data.grid_size
		for h in range(atk_square):
			test = GridData.tile.instantiate()
			var y_pos_offset = (h - atk_offset) * grid_data.grid_size
			test.position = Vector2((atk_pos.x + x_pos_offset), (atk_pos.y + y_pos_offset))
			test.name = "Attack at (" + str(w - atk_offset) + ", " + str(h - atk_offset) + ")"
			atk_node.add_child(test)
			#print("(", new_w, ", ", new_h, ")")
	
	print(atk_square, "x", atk_square)

func move(move_pos: Vector2i) -> Variant:
	#if true:
		#return Vector2i()
	return null

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if atk_node != null:
				atk_node.queue_free()
			attack(get_local_mouse_position(), test_size)
			
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_1:
			test_size = 1
		if event.keycode == KEY_2:
			test_size = 2
		if event.keycode == KEY_3:
			test_size = 3
