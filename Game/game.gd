extends Node2D

@onready var mainTileMap = $MainGameplay/TileMapLayer
@onready var multiplayerSpawner = $MainGameplay/MultiplayerSpawner
@onready var mainGameplay = $MainGameplay
@onready var troopSelector = $TroopSelector

#Constants
const troop_count: int = 5
const HostUnit = preload("res://Game/HostUnit.tscn")
#TODO create ClientUnit in the future when re introducing multiplayer

#Get gamestate logic script
@onready var gameState: GameStateLogic = preload("res://Game/gameStateLogic.gd").new()
var in_gamestate: bool = false

##TODO Take in host_units and client_units from TroopSelector.tscn
var host_units: Array = []
var client_units: Array = []

func _ready() -> void:
	gameState.deployTimer = $MainGameplay/DeploymentTimer
	gameState.startTimer = $MainGameplay/StartTimer
	gameState.planTimer = $MainGameplay/PlanningTimer
	
	for unit in host_units:
		add_units(HostUnit)

func _process(delta: float) -> void:
	if in_gamestate:
		gameState.updateGameState()
	#pass

#OwnedUnit means HostUnit or ClientUnit
func add_units(OwnedUnit):
	var unit = OwnedUnit.instantiate()
	mainTileMap.add_child(unit)
	HostUnit

func _on_troop_selector_selection_ended() -> void:
	troopSelector.visible = false
	mainGameplay.visible = true
	troopSelector.queue_free()
	print("Initialize game")
	in_gamestate = true
