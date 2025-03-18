extends TileMapLayer

class_name A_Star_2D

var A_Star := AStarGrid2D.new()
var Rect:Rect2 = Rect2i()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var Tile_Map_Size: Vector2i= get_used_rect().end - get_used_rect().position
	Rect = Rect2i(Vector2i.ZERO, Tile_Map_Size)
	
	var Tile_Size = tile_set.tile_size
	
	A_Star.region = Rect
	A_Star.cell_size = Tile_Size
	A_Star.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	A_Star.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	A_Star.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	A_Star.update()
	pass # Replace with function body.



func Is_Pos_Avilbel(Pos:Vector2) -> bool:
	var Local_To_Map:Vector2 = local_to_map(Pos)
	if Rect.has_point(Local_To_Map):
		return true
	return false
