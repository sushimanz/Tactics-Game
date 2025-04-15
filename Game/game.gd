extends Node2D

@onready var mainTileMap = $MainGameplay/TileMapLayer
@onready var multiplayerSpawner = $MainGameplay/MultiplayerSpawner
@onready var mainGameplay = $MainGameplay
@onready var troopSelector = $TroopSelector
@onready var hostUnits = $MainGameplay/TileMapLayer/Host
@onready var clientUnits = $MainGameplay/TileMapLayer/Client
@onready var musicManager = $MusicManager
@onready var deployBoxes = $MainGameplay/TroopDeployBoxes

#Troops
var troops = {}

#Constants
const troop_count: int = 5
const HostUnit = preload("res://Game/HostUnit.tscn")
#TODO create ClientUnit in the future when re introducing multiplayer

#Get gamestate logic script
var gameState = GameStateLogic.new()
var in_gamestate: bool = false

var deployables: Array = []
var set_to_troops: Array = []

var cur_troop: Troop

func _ready() -> void:
		#multiplayer Logic
	if Multiplayer.is_host:
		Multiplayer.is_multi = true
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			Multiplayer.is_multi = true
	)
	
	if Multiplayer.is_multi:
		print("GAME INITIALIZING / Waiting for other player")
	else:
		print("Initializing test / singleplayer game")
	
	musicManager.play_track(musicManager.select[randi_range(0, (len(musicManager.select)-1))])
	
	gameState.deployTimer = $MainGameplay/DeploymentTimer
	gameState.startTimer = $MainGameplay/StartTimer
	gameState.planTimer = $MainGameplay/PlanningTimer
	
	deployables = deployBoxes.get_children()
	
	for troop in deployables:
		troop.updateInfo.connect(_update_troop)

func _process(delta: float) -> void:
	if in_gamestate:
		gameState.updateGameState()

func add_units():
	var created_unit
	for unit in hostUnits.get_children():
		created_unit = unit.instantiate()
		hostUnits.add_child(created_unit)
	
	for unit in clientUnits.get_children():
		created_unit = unit.instantiate()
		clientUnits.add_child(created_unit)

func _update_troop(troop: Troop, idx: int) -> void:
	#print("index ",idx)
	if cur_troop != troop:
		cur_troop = troop
		deployables[idx].troop = cur_troop
		deployables[idx].texture = cur_troop.icon
		deployables[idx].troop_type = cur_troop.troop_type
		deployables[idx].label.text = cur_troop.troop_type

func _on_troop_selector_selection_ended(in_troops) -> void:
	#musicManager.play_track(musicManager.gameplay_music_name[randi_range(0, (len(musicManager.gameplay_music_name)-1))])
	
	troopSelector.visible = false
	mainGameplay.visible = true
	var i = 0
	for troop in in_troops:
		troops[troop] = in_troops[troop]
		#print(troop, " is ", troops[troop].troop_type)
		_update_troop(troops[troop], i)
		i += 1
	
	troopSelector.queue_free()
	print("Initialize game")
	in_gamestate = true
