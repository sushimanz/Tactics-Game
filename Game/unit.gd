class_name Unit
extends Node2D

#Get unit logic
var unitPlanning = UnitPlanning.new()

#
@onready var sprite: Sprite2D = $Sprite2D

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
	
	_reset_unit()

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
