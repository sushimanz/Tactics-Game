class_name DragBox
extends TextureRect

static var texture_size: Vector2 = Vector2(120, 120)

signal updateInfo(troop_str, troop)

@onready var troop_str: String = ($".").name
@onready var label = $Label
@onready var button = $BackgroundButton
@onready var troop = TroopTypeSelector.get_troop_type(troop_str)

@export var texture_icon: Texture2D
@export var can_drag: bool = true
@export var replace: bool = false

var mouse_btn_pressed: bool = false

func _ready() -> void:
	#print(troop_str, " Loaded")
	size = texture_size
	button.size = size
	label.text = troop_str
	
	connect("updateInfo", _on_mouse_entered)
	
	if troop is Troop:
		texture = troop.icon
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

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_btn_pressed = true
		else:
			mouse_btn_pressed = false

func _on_mouse_entered() -> void:
	if !mouse_btn_pressed:
		troop = TroopTypeSelector.get_troop_type(troop_str)
		if troop is Troop:
			emit_signal("updateInfo", troop_str, troop)
