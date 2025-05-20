extends Control

var grid = ResData.grid
var gridData: Dictionary[String, Unit]

var print_width: int

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
	
	print_width = width
	
	#Spawn in the tiles
	for h in height:
		for w in width:
			var new_tile = GridData.tile.instantiate()
			new_tile.position.y += (h * new_tile.size.y)
			new_tile.position.x += (w * new_tile.size.x)
			add_child(new_tile)
			new_tile.name = "(" + str(w + 1) + ", " + str(h + 1) + ")"
			gridData[new_tile.name] = null
			new_tile.troop_entered.connect(update_griddata)
			#print("Add gridbox at H:",h, "W:", w)

##This needs to be called EVERY time a unit enters, and exits, a tile.
func update_griddata(tile_name: String, unit: Unit) -> void:
	gridData[tile_name] = unit
	
	#This is for testing purposes
	var i: int = 1
	var j: String = ""
	print("Grid Data Updated")
	for tile in gridData:
		if i > print_width:
			i = 1
			j += "\n"
		
		i += 1
		j += str(tile) + " : " + str(gridData[tile]) + " | "
	
	print(j)
