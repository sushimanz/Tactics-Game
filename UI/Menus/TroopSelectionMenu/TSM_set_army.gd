class_name SetArmy
extends VBoxContainer

var h_boxes: int
var troops: int = (len(TroopData.troop_names) - 1)
var troop_index: int = 1

func _ready() -> void:
	print("Available Troops: ", troops)
	check_army_troop_division(troops)
	#print("Number of H Boxes: ", h_boxes)
	
	var max_troops_in_box: int = 5
	var troops_in_last_box: int = troops - (max_troops_in_box * (h_boxes - 1))
	#print("Troops in last box: ", troops_in_last_box)
	
	for h in range(h_boxes):
		#print("h: ", h)
		var box = HBoxContainer.new()
		box.alignment = BoxContainer.ALIGNMENT_CENTER
		add_child(box)
		
		if h == (h_boxes - 1):
			max_troops_in_box = troops_in_last_box
		for w in range(max_troops_in_box):
			var troop = ScenePathData.troopCard.instantiate()
			box.add_child(troop)
			troop.set_troop(troop_index)
			
			troop_index += 1

func check_army_troop_division(in_troops: int, extra_boxes: int = 0):
	#print(in_troops)
	if in_troops % 5 == 0:
		#print("Troops % 5 == 0")
		h_boxes = int(float(in_troops) / 5) + extra_boxes
	elif in_troops % 4 == 0:
		#print("Troops % 4 == 0")
		h_boxes = int(float(in_troops) / 4) + extra_boxes
	elif in_troops % 3 == 0:
		#print("Troops % 3 == 0")
		h_boxes = int(float(in_troops) / 3) + extra_boxes
	elif in_troops % 2 == 0:
		#print("Troops % 2 == 0")
		h_boxes = int(float(in_troops) / 2) + extra_boxes
	elif in_troops == 1:
		#print("Troops == 1")
		h_boxes = in_troops + extra_boxes
	else:
		check_army_troop_division(in_troops - 1, extra_boxes + 1)
