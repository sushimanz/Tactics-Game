extends Control

@export var gridbox: PackedScene = preload("res://UI/Interactables/GridBox/GridBox.tscn")
var data = PathData.res_grid

func set_grid(height: int = data.min_height, width: int = data.min_width) -> void:
	#Keep height and width within certain boundary
	if height < data.min_height:
		height = data.min_height
	elif height > data.max_height:
		height = data.max_height
	if width < data.min_width:
		width = data.min_width
	elif width > data.max_width:
		width = data.max_width
	
	#Spawn in grid
	for h in height:
		for w in width:
			var new_gridbox = gridbox.instantiate()
			new_gridbox.position.y += (h * new_gridbox.size.y)
			new_gridbox.position.x += (w * new_gridbox.size.x)
			add_child(new_gridbox)
			#print("Add gridbox at H:",h, "W:", w)
