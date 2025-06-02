class_name TroopPortrait
extends TextureRect

@export var troop_name: TroopData.NAME = TroopData.NAME.KNIGHT
@onready var portrait = $Portrait
var troop_frames: SpriteFrames

func _ready() -> void:
	set_portrait(troop_name)

func set_portrait(in_troop_name: TroopData.NAME) -> void:
	##Not sure what the actual names and assign values will be, but to give an idea:
	#texture = team.texture
	var troop = UnitData.get_troop(in_troop_name)
	portrait.texture = troop.portrait.get_frame_texture("high", 0)#troop.team.texture
	tooltip_text = str(troop.troop_name_desc)
