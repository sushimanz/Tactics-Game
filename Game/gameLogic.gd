class_name GameLogic
extends TileMapLayer

var units: Array = []
var tick: int = 0
@onready var tickTimer = $"../TickTimer"
@onready var readyInd = $"../UI/p1ReadyInd"
@onready var remoteReadyInd = $"../UI/p2ReadyInd"
@onready var troopDeployBoxes = $"../TroopDeployBoxes"

var hostUnit = load("res://Game/HostUnit.tscn")
#var clientUnit = load("res://Game/ClientUnit.tscn")
#@onready var hosts = $Host
#@onready var clients = $Client

var deploy_location = Vector2i.ZERO
var can_deploy: bool = false
@export var map_bounds = [Vector2i(0, 0), Vector2i(13, 7)]

var obstructed = {}

#Multiplayer
#var is_multiplayer: bool = false
var localReady: bool = false
var remoteReady: bool = false

@onready var deployables = troopDeployBoxes.get_children()

func _ready() -> void:
	for x in range(map_bounds[0].x, map_bounds[1].x):
		for y in range(map_bounds[0].y, map_bounds[1].y):
			obstructed[Vector2i(x, y)] = false
	
	for troop in deployables:
		troop.deployTroop.connect(_try_to_deploy)

func deploy_unit(troop):
	var created_unit = hostUnit.instantiate()
	
	add_child(created_unit)
	# Temporarily commented out to try and get it running  -Jakobre
	created_unit.position = map_to_local(deploy_location)
	#created_unit.set_troop_values(troop)


func add_units():
	var created_unit
	for unit in get_children():
		created_unit = unit.instantiate()
		add_child(created_unit)
	
	#for unit in clients.get_children():
		#created_unit = unit.instantiate()
		#clients.add_child(created_unit)


func _try_to_deploy(troop, troopID):
	for deployable_troop in deployables:
		if deployable_troop.name == troopID:
			#print(deployable_troop.name)
			var temp = local_to_map(get_local_mouse_position())
			var is_valid_x = temp.x >= map_bounds[0].x and temp.x < map_bounds[1].x
			var is_valid_y = temp.y >= map_bounds[0].y and temp.y < map_bounds[1].y
			
			#Only do deploy at a valid location
			if is_valid_x and is_valid_y:
				can_deploy = true
				deploy_location = temp
				#print(deploy_location)
			else:
				can_deploy = false
			
			if can_deploy and (obstructed[deploy_location] == false):
				print("Can Deploy ", deployable_troop.name," the ", deployable_troop.troop.troop_type, " at ", deploy_location)
				obstructed[deploy_location] = true
				deploy_unit(deployable_troop.troop)
				deployable_troop._disable()
			else:
				print("Can't deploy troop here! Location is obstructed.")

#@rpc("any_peer","call_local", "reliable")
func roundTick() -> void:
	var check: bool
	for unit in units:
		#Check next tick for updates to the unit
		unit._check_for_next_tick()
		
		var test = unit.tickUpdate(tick)
		if !check:
			check = test
	tick += 1
	
	## if all units dont have any moves left end the turn
	if !check:
		tickTimer.stop()
		tick = 0
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
		readyInd.color = Color(1.0,0.0,0.0,1.0)
		localReady = false
		remoteReady = false
		print("round end")

func checkLocation(locIn : Vector2) -> bool:
	return obstructed[local_to_map(locIn)] == false

func _locUpdate(locIn : Vector2, oldLoc: Vector2) -> void:
	obstructed[local_to_map(locIn)] = true
	obstructed[local_to_map(oldLoc)] = false

func _process(delta: float) -> void:
	pass

func _on_tick_timer_timeout() -> void:
	roundTick()


func _on_button_pressed() -> void:
	if !localReady:
		localReady = true
		readyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		localReady = false
		readyInd.color = Color(1.0,0.0,0.0,1.0)
	
	##Old multiplayer stuff
	if Multiplayer.is_multi:
		remoteReadyCheck.rpc(localReady)



##Old multiplayer stuff
@rpc("any_peer","call_remote","reliable")
func remoteReadyCheck(inReady) -> void:
	#print(multiplayer.get_unique_id())
	remoteReady = inReady
	if remoteReady:
		remoteReadyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
	
	if Multiplayer.is_multi:
		if inReady and localReady:
			print("Both players ready, Starting round")
			#startRound.rpc()
	else:
		pass
		#startRound.rpc()
