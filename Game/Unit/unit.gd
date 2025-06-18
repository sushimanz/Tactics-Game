class_name Unit
extends Control
##Unit. This is the main Node that the player has control over.

signal _unit_selected(unit_id: Unit)

@onready var sprite: AnimatedSprite2D = $Sprite

##How much a reinforcement should reduce the current reinforcements by
@export var spawn_loss: int = 1

##Whether a troop is friendly
var friendly: bool = false

##Troop data reference
var troop: TroopData
var troop_name: TroopData.NAME
var names: Array = TroopData.troop_names

##Whether the mouse is hovering over a unit
var mouse_hover: bool = false

##Where the unit should move to on the grid 
##(TODO Create a function that uses the tween thing or whatever it's called to get it to move smoothly)
var goto_pos_array: Array[Vector2i]
##The current position based on the grid
var grid_position: Vector2i

var path_line: Line2D = Line2D.new()
var tile_size: Vector2

func _ready() -> void:
	update_troop(troop_name)
	add_child(path_line)
	tile_size = GridData.gridArray[grid_position.x][grid_position.y].size
	print("tile_size: ", tile_size)
	path_line.add_point(path_line.position + tile_size/2)

##Change troop values to match a troop NAME input
func update_troop(in_troop: TroopData.NAME = TroopData.NAME.UNKNOWN):
	print("Updating Troop to ", names[in_troop])
	
	troop_name = in_troop
	troop = set_troop(UnitData.get_troop(in_troop))
	
	#FIXME??? Need to fix, something with it beign a Nil value... need to wait to update troop until on_ready??
	sprite.sprite_frames = troop.sprite_sheet
	sprite.play("idle")
	
	##Check for sprite frame texture
	if sprite.sprite_frames.get_frame_texture("idle", 0):
		var sprite_size: Vector2 = sprite.sprite_frames.get_frame_texture("idle", 0).get_size()
		
		##If sprite frame texture is larger than it should be, offset the difference
		if sprite_size != size:
			#This should make it so that the feet are at the bottom of a tile
			sprite.offset.y = (size.y - sprite_size.y)/2
	else:
		print("There are not sprite_frames textures for ", names[in_troop])
	
	#Set troop names
	if friendly:
		name = "Friendly " + troop.troop_name_desc
		#Do troop name and sprite to actual stuff
		#TODO MULTIPLAYER: Send over this unit's troop NAME, as enemy, and its position that it spawns at to the opposing player
	else:
		name = "Enemy " + troop.troop_name_desc
		#Do troop name and sprite to UNKNOWN stuff ("Hidden" until dealing or taking damage)
	
	position = GridData.gridArray[grid_position.x][grid_position.y].position
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

##Take damage, but also works for healing. 
##TODO check for if the "damage" was done by a friendly troop or not, since there is not friendly fire
func take_damage(dmg: int = 0):
	#Do heal
	if dmg < 0:
		print("Healing done to ", name)
		if (troop.current_health - dmg) > troop.max_health:
			troop.current_health = troop.max_health
		else:
			troop.current_health -= dmg
	#Do damage
	else:
		print("Damage done to ", name)
		if (troop.current_health - dmg) < 0:
			troop.current_health = 0
		
		if troop.current_health <= 0:
			if troop.current_reinforcements > 0:
				print(name, " Has perished, and instantly been reinforced at its exact location")
				troop.current_reinforcements -= spawn_loss
				troop.current_health = troop.max_health
			else:
				print(name, " Has perished, and has no reinforcements")
				GridData.gridArray[grid_position.x][grid_position.y].troop_exited()
				queue_free()
	
	tooltip_text = troop.troop_name_desc + "\nHealth: " + str(troop.current_health) + "\nReinforcements: " + str(troop.current_reinforcements)

func _input(event: InputEvent) -> void:
	if troop != null:
		if event is InputEventMouseButton and event.is_pressed():
			if mouse_hover:
				if event.button_index == MOUSE_BUTTON_LEFT:
					pass
					#take_damage(999)
					#print("This has been done in unit.gd _input() call, and is ONLY for testing purposes (Remove when done with testing)")
				#if event.button_index == MOUSE_BUTTON_RIGHT:
					#if troop_name + 1 < len(names):
						#update_troop(troop_name + 1)
					#else:
						#update_troop()
		elif event is InputEventMouseButton and event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT:
				if !mouse_hover:
					_unit_selected.emit()

func _on_mouse_entered() -> void:
	GridData.gridArray[grid_position.x][grid_position.y]._on_mouse_entered()
	mouse_hover = true

func _on_mouse_exited() -> void:
	GridData.gridArray[grid_position.x][grid_position.y]._on_mouse_exited()
	mouse_hover = false

func update_path(in_pos: Vector2i = Vector2i.ZERO) -> void:
	#if goto_pos_array.is_empty():
		#path_line.add_point(position)
		#print("Add Path INIT")
	
	var offset: Vector2i = in_pos - grid_position
	#print("offset: ", offset)
	#print("tile_size: ", tile_size)
	var new_pos: Vector2 = Vector2(offset.x * tile_size.x, offset.y * tile_size.y) + Vector2(tile_size)/2
	#print("new_pos: ", new_pos)
	
	#Create a line2d and such
	if in_pos != grid_position:
		if !goto_pos_array.is_empty():
			if in_pos != goto_pos_array[(goto_pos_array.size() - 2)]:
				goto_pos_array.append(in_pos)
				path_line.add_point(new_pos, goto_pos_array.size())
				print("Add to Path")
			else:
				path_line.remove_point(goto_pos_array.size())
				goto_pos_array.remove_at((goto_pos_array.size() - 1))
				print("Remove Recent Path")
		else:
			goto_pos_array.append(in_pos)
			path_line.add_point(new_pos, goto_pos_array.size())
			print("Add Path INIT")
			
	#elif goto_pos_array.size() >= 1:
		#if in_pos == goto_pos_array[(goto_pos_array.size() - 2)]:
			#path_line.remove_point(goto_pos_array.size())
			#if goto_pos_array.size() >= 1:
				#goto_pos_array.remove_at((goto_pos_array.size() - 1))
				#print("Remove Recent Path")

##NOTE FOR ALL DRAG DATA:
##Should send to a tile, or another troop (Which then transfers to its occupied tile)
func _get_drag_data(_at_position: Vector2) -> Variant:
	if troop != null:
		var data: Unit = self
		_unit_selected.emit(self)
		
		var drag_card: TextureRect = TextureRect.new()
		drag_card.texture = troop.icon
		drag_card.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		drag_card.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
		drag_card.size = size * 4/5
		drag_card.modulate.a = 0.7
		drag_card.visible = true
		var control = Control.new()
		control.add_child(drag_card)
		drag_card.position -= drag_card.size / 2
		
		set_drag_preview(control)
		
		return data
	return null

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Unit and data != self:
		return true
	return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
		if data.friendly:
			print("Do a friendly thing!")
			#Put move action into the queue (Goto position) / maybe do a heal if troop can do that?
			#if data.troop_name == healing_troop_name... and can_heal...
			#data.goto_position = ...
			pass
		
		else:
			print("Do a hostile thing!")
			#Put attack action into the queue, since tile is occupied by enemy
			#tile_occupied
			pass
