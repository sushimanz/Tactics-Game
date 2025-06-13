class_name TroopPortrait
extends TextureRect

@export var troop_name: TroopData.NAME = TroopData.NAME.KNIGHT
var troop: TroopData
@onready var portrait = $Portrait
var troop_frames: SpriteFrames
var draggable = true

func _ready() -> void:
	set_portrait(troop_name)

func set_portrait(in_troop_name: TroopData.NAME) -> void:
	##Not sure what the actual names and assign values will be, but to give an idea:
	#texture = team.texture
	troop = UnitData.get_troop(in_troop_name)
	troop_name = troop.troop_name
	#print("Troop Portrait Initialized: ", troop.troop_name_desc)
	portrait.texture = troop.portrait.get_frame_texture("high", 0)#troop.team.texture
	tooltip_text = str(troop.troop_name_desc)

func _get_drag_data(_at_position: Vector2) -> Variant:
	if draggable:
		#print("Grabbed Portrait, Dragging...")
		
		var drag_card: TextureRect = TextureRect.new()
		drag_card.texture = troop.icon
		drag_card.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		drag_card.size = size * 2/5
		drag_card.modulate.a = 0.7
		drag_card.visible = true
		var control = Control.new()
		control.add_child(drag_card)
		drag_card.position -= drag_card.size / 2
		
		set_drag_preview(control)
		
		return [self, troop_name]
		
	return null
	
