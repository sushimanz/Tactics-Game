class_name Unit
extends Control

@onready var sprite = $Sprite

##Just a test value, unless it becomes a feature in the future
@export var spawn_loss: int = 1

var friendly: bool = false
var troop: TroopData
var cur_troop: TroopData.NAME
var names := TroopData.NAME.keys()
var feet: Vector2 = position + Vector2((size.x / 2), size.y)

var mouse_hovered: bool = false

func _ready() -> void:
	update_troop()

func update_troop(in_troop: TroopData.NAME = TroopData.NAME.UNKNOWN):
	print("Updating Troop to ", names[in_troop])
	
	cur_troop = in_troop
	troop = set_troop(UnitData.get_troop(in_troop))
	sprite.sprite_frames = troop.sprite_sheet
	sprite.play("idle")
	
	if friendly:
		name = "Friendly " + troop.troop_name_desc
		#Do troop name and sprite to actual stuff
	else:
		name = "Enemy " + troop.troop_name_desc
		#Do troop name and sprite to UNKNOWN stuff
	
	tooltip_text = troop.troop_name_desc + "\nHealth: " + str(troop.current_health) + "\nReinforcements: " + str(troop.current_reinforcements)

func set_troop(in_troop: TroopData) -> TroopData:
	var data = in_troop.duplicate()
	
	data.current_health = data.max_health
	data.current_actions = data.max_actions
	data.current_attacks = data.max_attacks
	data.current_moves = data.max_moves
	data.current_reinforcements = data.max_reinforcements
	
	return data

#This is the check when an attack happens, not in planning or before it occurs
func check_attack(dmg: int = 0) -> bool:
	var valid_attack: bool = false
	
	#This only checks for friendly fire or "helping" the enemy, which currently does not happen in this game
	#Can be used as a means to figure out if a marker should be shown for an attack or heal/buff
	if friendly and dmg <= 0:
		#Give buff/heal
		valid_attack = true
	elif !friendly and dmg >= 0:
		#Give debuff/damage
		valid_attack = true
	
	if valid_attack:
		take_damage(dmg)
	
	return valid_attack

##This should NEVER be called outside of check_attack()
func take_damage(dmg: int = 0):
	print("Damage done to ", name)
	troop.current_health -= dmg
	if troop.current_health <= 0:
		if troop.current_reinforcements > 0:
			print(name, " Has perished, and instantly been reinforced at its exact location")
			troop.current_reinforcements -= spawn_loss
			troop.current_health = troop.max_health
		else:
			print(name, " Has perished, and has no reinforcements")
			#if feet leave a tile, maybe emit a signal?
			queue_free()
	tooltip_text = troop.troop_name_desc + "\nHealth: " + str(troop.current_health) + "\nReinforcements: " + str(troop.current_reinforcements)

func _input(event: InputEvent) -> void:
	if troop != null:
		if event is InputEventMouseButton and event.is_pressed():
			if mouse_hovered:
				if event.button_index == MOUSE_BUTTON_LEFT:
					take_damage(999)
					print("This has been done in unit.gd _input() call, and is ONLY for testing purposes (Remove when done with testing)")
				if event.button_index == MOUSE_BUTTON_RIGHT:
					if cur_troop + 1 < len(names):
						update_troop(cur_troop + 1)
					else:
						update_troop()

func _on_mouse_entered() -> void:
	mouse_hovered = true

func _on_mouse_exited() -> void:
	mouse_hovered = false
