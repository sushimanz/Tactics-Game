extends Control

var grid = ResData.grid
#var gridData: Dictionary[Tile, Unit]
var gridArray
signal _add_unit(unit_id: Unit, is_friendly: bool)

var grid = ResData.grid

var gridData: Array

#This is just for printing stuff in the console
var print_width: int


func set_grid(height: int = grid.min_height, width: int = grid.min_width) -> void:
	gridArray = create_2d_array(width, height, null)
	#gridData.clear()
func spawn_troop(tile: Tile, in_troop: TroopData.NAME, is_friendly: bool = false) -> void:
	var new_unit = UnitData.unit.instantiate()
	
	new_unit.friendly = is_friendly
	#new_unit.position -= Vector2(0, tile.size.y)/4
	
	_add_unit.emit(new_unit, is_friendly)
	
	new_unit.update_troop(in_troop)
	tile.troop_entered(new_unit)
	
	new_unit.position = new_unit.tile_occupied.position
	print("Spawned Unit Tile: ", new_unit.tile_occupied)

func clear_grid() -> void:
	for old_tile in get_children():
		old_tile.queue_free()

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
	gridData = UtilityData.create_2d_array(width, height)
	
	#Spawn in the tiles
	for w in width:
		for h in height:
			var new_tile: Tile = GridData.tile.instantiate()
			new_tile.position.y += (h * new_tile.size.y)
			new_tile.position.x += (w * new_tile.size.x)
			add_child(new_tile)
			new_tile.grid_position = Vector2i(w, h)
			
			new_tile._spawn_troop.connect(spawn_troop)
			new_tile._troop_passed.connect(update_griddata)
			
			gridData[w][h] = new_tile
			#print("Add gridbox at H:",h, "W:", w)
	
	print("GridData instanced")
	print(gridData)

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
