class_name Unit
extends Node2D

#signals
signal locationUpdated

#Get unit logic
var unitPlanning = UnitPlanning.new()

#
@onready var sprite: Sprite2D = $Sprite2D
@onready var coll: Area2D = $Collision
@onready var tilemap: GameLogic = $".."

#Mouse
var mouseHovering : bool = false
var mouseHeld : bool = false
var dragging : bool = false

var tempLoc : Vector2

#Actions
var selected:bool
var planned_actions = {}

#Multiplayer
@onready var syncer: MultiplayerSynchronizer = $MultiplayerSynchronizer
var playerID: int = 0

#Troop Type default values
@export var troop_type: String = "troopname"
@export var max_health: int = 100
@export var max_moves: int = 12
@export var max_attacks: int = 12
@export var max_reinforcements: int = 12
@export var reinforce_turns: int = 12
@export var dmg: int = 50
@export var atk_range: int = 10
@export var max_troops_hit: int = 5
@export var icon: CompressedTexture2D = preload("res://Assets/Icons/KNIGHT_ICON.png")

#Current Values
var health: int = max_health
var moves: int = max_moves
var attacks: int = max_attacks
var reinforcements: int = max_reinforcements

#Location
var coords: Vector2i

func set_troop_values(troop: Troop) -> void:
	print(troop.troop_type," initialized.")
	if troop:
		if troop is Troop:
			troop_type = troop.troop_type
			max_health = troop.max_health
			max_moves = troop.max_moves
			max_attacks = troop.max_attacks
			max_reinforcements = troop.reinforcements
			reinforce_turns = troop.reinforce_turns
			dmg = troop.dmg
			atk_range = troop.atk_range
			max_troops_hit = troop.max_troops_hit
			icon = troop.icon
			sprite.texture = icon
	
	#If not a troop, or not valid input (null)
	else:
		print("Initialization failed for troop ", troop)
	
	#Always update current stats to whatever max stats are at initialization
	_spawn_unit()

#Reset actions and clear path
func _reset_unit():
	planned_actions.clear()
	#unitPlanning.path.clear_points()
	#unitPlanning.movePath.clear()

#Do when spawning a unit (Reinforce = respawn)
func _spawn_unit():
	health = max_health
	moves = max_moves
	attacks = max_attacks
	reinforcements= max_reinforcements
	locationUpdated.connect(tilemap._locUpdate)
	
	_reset_unit()

#called via signal from area2d
func _mouseUpdate(status) -> void:
	mouseHovering = status
	var tween = get_tree().create_tween()
	if !mouseHeld:
		if status:
			tween.tween_property(sprite, "scale", Vector2(1.11,1.11), 0.1)
		else:
			tween.tween_property(sprite, "scale", Vector2(1,1), 0.1)

func _process(_delta: float) -> void:
	#WIP troop drag and drop
	if dragging:
		coll.global_position = get_global_mouse_position()
	sprite.global_position = lerp(sprite.global_position,coll.global_position, 0.1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LClick"):
		mouseHeld = true
		if mouseHovering:
			dragging = true
			tempLoc = coll.position
	elif event.is_action_released("LClick"):
		if dragging:
			#check location and place
			if tilemap.checkLocation(coll.position):
				coll.position = tilemap.map_to_local(tilemap.local_to_map(coll.position))
				locationUpdated.emit(coll.position, tempLoc)
			else:
				coll.position = tempLoc
		mouseHeld = false
		dragging = false
