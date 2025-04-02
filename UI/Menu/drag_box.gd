class_name DragBox
extends TextureRect

static var texture_size: Vector2 = Vector2(120, 120)

@onready var troop_str: String = ($".").name
@onready var label = $Label
@export var texture_icon: Texture2D
@export var can_drag: bool = true
@export var replace: bool = false

func _ready() -> void:
	print(troop_str, " Loaded")
	size = texture_size
	label.text = troop_str
	
	if TroopTypeSelector.get_troop_type(troop_str) is Troop:
		texture = TroopTypeSelector.get_troop_type(troop_str).icon
	else:
		texture = texture_icon
	

func _get_drag_data(at_position: Vector2) -> Variant:
	if can_drag:
		var preview_texture = TextureRect.new()
		
		preview_texture.texture = texture
		preview_texture.expand_mode = 1
		preview_texture.size = texture_size
		
		var preview = Control.new()
		preview.add_child(preview_texture)
		set_drag_preview(preview)
		
		if replace:
			texture = null
			return [troop_str, preview_texture.texture]
		else:
			return [troop_str, texture]
	return

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if replace:
		troop_str = data[0]
		texture = data[1]
		label.text = troop_str
