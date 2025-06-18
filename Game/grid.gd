class_name Grid
extends Control

signal _add_unit(unit_id: Unit, is_friendly: bool)

var gridData: GridData = ResData.grid
var selected_unit: Unit

##
#var grid2dArray: Array

#This is just for printing stuff in the console
var print_width: int

func spawn_troop(grid_position: Vector2i, in_troop: TroopData.NAME, is_friendly: bool = false) -> void:
	var new_unit = UnitData.unit.instantiate()
	var tile: Tile = GridData.gridArray[grid_position.x][grid_position.y]
	
	new_unit.troop_name = in_troop
	new_unit.friendly = is_friendly
	#add_child(new_unit)
	
	tile.troop_entered(new_unit)
	
	#new_unit.position = tile.position
	print("Spawned Unit Tile: ", tile)
	
	_add_unit.emit(new_unit, is_friendly)

func clear_grid() -> void:
	for old_tile in get_children():
		old_tile.queue_free()

func set_grid(height: int = gridData.min_height, width: int = gridData.min_width) -> void:
	#Keep height and width within certain boundary
	if height < gridData.min_height:
		height = gridData.min_height
	elif height > gridData.max_height:
		height = gridData.max_height
	if width < gridData.min_width:
		width = gridData.min_width
	elif width > gridData.max_width:
		width = gridData.max_width
	
	print_width = width
	gridData.gridArray = UtilityData.create_2d_array(width, height)
	
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
			new_tile._mouse_entered.connect(update_mouse_grid)
			
			gridData.gridArray[w][h] = new_tile
			#print("Add gridbox at H:",h, "W:", w)
	
	print("GridData instanced")
	print(gridData.gridArray)


func update_mouse_grid(in_grid_pos: Vector2i = Vector2i.ZERO) -> void:
	print("Update Grid Location to: ", in_grid_pos)
	
	if selected_unit:
		selected_unit.update_path(in_grid_pos)

##This needs to be called EVERY time a unit enters, and exits, a tile.
func update_griddata(grid_position: Vector2i) -> void:
	var tile: Tile = GridData.gridArray[grid_position.x][grid_position.y]
	
	print(tile, " Has been updated")
	#print(gridData.gridArray)

#%Friendlies
#%Enemies

func troop_moved() -> void:
	pass
