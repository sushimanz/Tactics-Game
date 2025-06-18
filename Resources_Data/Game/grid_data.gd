class_name GridData
extends Resource

const tile: PackedScene = preload("res://UI/Interactables/Tile/Tile.tscn")

static var gridArray: Array[Array]

@export var min_height: int = 5
@export var min_width: int = 8
@export var max_height: int = 10
@export var max_width: int = 24

var cur_height: int = min_height
var cur_width: int = min_width
