extends Control

var grid = ResData.grid

func set_grid(height: int = grid.min_height, width: int = grid.min_width) -> void:
	#Keep height and width within certain boundary
	if height < grid.min_height:
		height = grid.min_height
	elif height > grid.max_height:
		height = grid.max_height
	if width < grid.min_width:
		width = grid.min_width
	elif width > grid.max_width:
		width = grid.max_width
	
	#Spawn in grid
	for h in height:
		for w in width:
			var new_gridbox = GridData.gridbox.instantiate()
			new_gridbox.position.y += (h * new_gridbox.size.y)
			new_gridbox.position.x += (w * new_gridbox.size.x)
			add_child(new_gridbox)
			new_gridbox.name = "Tile (" + str(w) + ", " + str(h) + ")"
			#print("Add gridbox at H:",h, "W:", w)
