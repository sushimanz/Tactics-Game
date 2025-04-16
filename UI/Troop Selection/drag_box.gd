class_name DragBox
extends TextureRect

static var texture_size: Vector2 = Vector2(120, 120)

signal updateInfo(troop)
signal deployTroop(troop, name)

@onready var texture_box = $"."
@onready var label = $Label
@onready var button = $BackgroundButton
@onready var troop = TroopMatcher.get_troop_type(name)
var troop_type = name

@export var texture_icon: Texture2D
@export var can_drag: bool = true
@export var replace: bool = false
@export var deployable: bool = false

var l_mouse_btn_held: bool = false
var dragging: bool = false
var disabled: bool = false

##TODO
#See if you can spawn a unit on a tile
#I.E. drag over a valid tile ((0,0) to (13,7)), if tile is valid, delete the drag_box and spawn in a unit
#Use the troop var, just do something like:
#spawn unit						<-- I think Unit.new()? Not sure
#unit.value = troop.value		<-- Replace value with actual value name

func _disable():
	disabled = true
	can_drag = false
	replace = false
	deployable = false
	dragging = false

func _ready() -> void:
	#print(troop_type, " Loaded")
	size = texture_size
	button.size = size
	label.text = name
	
	if troop is Troop:
		texture = troop.icon
	else:
		texture = texture_icon

func _get_drag_data(at_position: Vector2) -> Variant:
	if not disabled:
		#print("Get Troop ", name)
		if deployable:
			if l_mouse_btn_held:
				dragging = true
		
		if can_drag:
			var preview_texture = TextureRect.new()
			
			preview_texture.texture = texture
			preview_texture.expand_mode = 1
			preview_texture.size = texture_size
			preview_texture.set_self_modulate(Color(1.0, 1.0, 1.0, 0.5))
			
			var preview = Control.new()
			preview.add_child(preview_texture)
			set_drag_preview(preview)
			
			if replace:
				texture = null
				texture_icon = preview_texture.texture
			return troop
	
	return

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if not disabled:
		return data is Troop
	
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if not disabled:
		#print("Data dropped into ", name)
		
		#This needs to happen if dropped on the map, not sure how to do yet
		if replace:
			troop = data
			troop_type = troop.troop_type
			texture = troop.icon
			label.text = troop.troop_type
		
		#print(name, " is now ", troop.troop_type)

func _input(event: InputEvent) -> void:
	if not disabled:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					l_mouse_btn_held = true
				else:
					l_mouse_btn_held = false
					if dragging:
						dragging = false
						#This needs to happen if dropped on the map, not sure how to do yet
						if deployable:
							#print(name, " is deployable")
							if troop is Troop:
								#print(name, " is a troop")
								emit_signal("deployTroop", troop, name)

func _on_mouse_entered() -> void:
	if !l_mouse_btn_held:
		if troop is Troop:
			emit_signal("updateInfo", troop)
