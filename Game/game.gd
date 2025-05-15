extends Control

@onready var grid = $Grid
@export var gridbox: PackedScene = preload("res://UI/Interactables/GridBox/GridBox.tscn")

@export var min_height: int = 5
@export var min_width: int = 6
@export var max_height: int = 10
@export var max_width: int = 24

func _init() -> void:
	pass

func _ready() -> void:
	set_grid()

func set_grid(height: int = min_height, width: int = min_width) -> void:
	#Keep height and width within certain boundary
	if height < min_height:
		height = min_height
	elif height > max_height:
		height = max_height
	if width < min_width:
		width = min_width
	elif width > max_width:
		width = max_width
	
	#Spawn in grid
	for h in height:
		for w in width:
			var new_gridbox = gridbox.instantiate()
			new_gridbox.position.y += (h * new_gridbox.size.y)
			new_gridbox.position.x += (w * new_gridbox.size.x)
			grid.add_child(new_gridbox)
			#print("Add gridbox at H:",h, "W:", w)
