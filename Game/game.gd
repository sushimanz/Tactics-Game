extends Node2D

@onready var mainTileMap = $MainGameplay/TileMapLayer
@onready var multiplayerSpawner = $MainGameplay/MultiplayerSpawner
@onready var mainGameplay = $MainGameplay
@onready var troopSelector = $TroopSelector
@onready var musicManager = $MusicManager
@onready var deployBoxes = $MainGameplay/TroopDeployBoxes

#Constants
const troop_count: int = 5
const HostUnit = preload("res://Game/HostUnit.tscn")
#TODO create ClientUnit in the future when re introducing multiplayer

#Get gamestate logic script
var gameState = GameStateLogic.new()
var in_gamestate: bool = false

##TODO Take in host units and client units from TroopSelector.tscn
var host_units: Array = []
var client_units: Array = []
var deployables: Array = []
var set_to_troops: Array = []

var cur_troop: Troop

func _ready() -> void:
	musicManager.play_track(musicManager.select[randi_range(0, (len(musicManager.select)-1))])
	
	gameState.deployTimer = $MainGameplay/DeploymentTimer
	gameState.startTimer = $MainGameplay/StartTimer
	gameState.planTimer = $MainGameplay/PlanningTimer
	
	deployables = deployBoxes.get_children()
	
	for troop in deployables:
		troop.updateInfo.connect(_update_troop)
	
	for unit in host_units:
		add_units(HostUnit)

func _process(delta: float) -> void:
	if in_gamestate:
		gameState.updateGameState()
	#pass

##NOTE: deployables[idx].troop is how you get the troop class values 
#You could do something like troop = deployables[idx].troop for each deployable so you don't have to write as much
#It would be better check drag_box.gd, and see if you can spawn a unit on a tile
#I.E. drag over a valid tile ((0,0) to (13,7)), if tile is valid, delete the drag_box and spawn in a unit
#Use the troop var in there, just do something like:
#spawn unit						<-- I think Unit.new()? Not sure
#unit.value = troop.value		<-- Replace value with actual value name

func _update_troop(troop: Troop, idx: int) -> void:
	if troop != cur_troop:
		cur_troop = troop
		deployables[idx].troop = troop
		deployables[idx].texture = troop.icon
		deployables[idx].troop_type = troop.troop_type
		deployables[idx].label.text = troop.troop_type

#OwnedUnit means HostUnit or ClientUnit
func add_units(OwnedUnit):
	var unit = OwnedUnit.instantiate()
	mainTileMap.add_child(unit)

func _on_troop_selector_selection_ended(troops) -> void:
	#musicManager.play_track(musicManager.gameplay_music_name[randi_range(0, (len(musicManager.gameplay_music_name)-1))])
	
	troopSelector.visible = false
	mainGameplay.visible = true
	var i = 0
	for troop in deployables:
		_update_troop(troops[i], i)
		i += 1
	troopSelector.queue_free()
	print("Initialize game")
	in_gamestate = true
