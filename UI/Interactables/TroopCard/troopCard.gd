class_name TroopCard
extends Control

signal squad_troop_set(troop: TroopData)

var troop: TroopData

@export var army: bool = true
var squad: bool = false
var assigned: bool = false
var being_dragged: bool = false

var troop_name: TroopData.NAME = TroopData.NAME.UNKNOWN

@onready var troopCharacter: AnimatedSprite2D = $CardBG/TroopCharacter
@onready var troopIcon: TextureRect = $CardBG/TroopIcon
@onready var troopLabel: Label = $CardBG/LabelBG/Label

func _ready() -> void:
	#Might use to limit what troops can be taken in, since 1 per troop type
	squad = !army
	assigned = army

func _input(event: InputEvent) -> void:
	if being_dragged:
		if event is InputEventMouseButton and event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			being_dragged = false
			visible = true
			mouse_filter = Control.MOUSE_FILTER_STOP

func set_troop(in_troop_name: TroopData.NAME) -> void:
	troop = UnitData.get_troop(in_troop_name)
	print("Troop Card Initialized: ", TroopData.troop_names[troop.troop_name])
	troop_name = troop.troop_name
	troopCharacter.sprite_frames = troop.sprite_sheet
	if troop.sprite_sheet != null:
		troopCharacter.play("idle")
		
	troopIcon.texture = troop.icon
	troopLabel.text = TroopData.troop_names[troop.troop_name]
	name = troop.troop_name_desc
	tooltip_text = troop.troop_name_desc + "\nMax Health: " + str(troop.max_health) + "\nMax Moves: " + str(troop.max_moves) + "\nMove Speed: " + str(troop.move_speed) + "\nAttack Range: " + str(troop.atk_range)
	
	if !troop.attack_types.is_empty():
		tooltip_text += "\nAttack Types: "
		for attack in troop.attack_types:
			if attack != troop.attack_types.keys()[-1]:
				tooltip_text += attack + " | " + str(troop.attack_types[attack]) + "\n"
			else:
				tooltip_text += attack + " | " + str(troop.attack_types[attack])

func _get_drag_data(_at_position: Vector2) -> Variant:
	if army:
		print("Grabbed ", name)
		being_dragged = true
		visible = false
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		var drag_card = duplicate()
		drag_card.modulate.a = 0.7
		drag_card.visible = true
		var control = Control.new()
		control.add_child(drag_card)
		drag_card.position -= drag_card.size/2
		drag_card.rotation_degrees += 5
		
		set_drag_preview(control)
		
		return self
	
	elif !assigned:
		pass
	
	return null

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return ((data is TroopCard) and (data != self))

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	print(data.name, " was dropped into ", name)
	print(typeof(data), " data is ", data)
	if assigned:
		print("Can swap")
		var temp = troop_name
		set_troop(data.troop_name)
		data.set_troop(temp)
	else:
		print("Can replace")
		set_troop(data.troop_name)
		assigned = true
		data.queue_free()
	
	if squad:
		squad_troop_set.emit(troop)

func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	scale = Vector2(1.0, 1.0)
