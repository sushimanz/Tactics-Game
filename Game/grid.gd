extends Control

var grid = ResData.grid
#var gridData: Dictionary[Tile, Unit]
var gridArray

var print_width: int


func set_grid(height: int = grid.min_height, width: int = grid.min_width) -> void:
	gridArray = create_2d_array(width, height, null)
	#gridData.clear()
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
			var new_tile: Tile = GridData.tile.instantiate()
			new_tile.position.y += (h * new_tile.size.y)
			new_tile.position.x += (w * new_tile.size.x)
			add_child(new_tile)
			new_tile.name = "(" + str(w + 1) + ", " + str(h + 1) + ")"
			gridArray[h][w] = new_tile
			#new_tile.troop_entered.connect(update_griddata)
			#print("Add gridbox at H:",h, "W:", w)

##This needs to be called EVERY time a unit enters, and exits, a tile.
#func update_griddata(tile_id: Tile, unit_d: Unit) -> void:
	#gridData[tile_id] = unit_d
	#
	##This is for testing purposes
	#var i: int = 1
	#var j: String = ""
	#print("Grid Data Updated")
	#for tile in gridData:
		#if i > print_width:
			#i = 1
			#j += "\n"
		#
		#i += 1
		#j += str(tile) + " : " + str(gridData[tile]) + " | "
	#
	#print(j)

func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value
			
	return a
