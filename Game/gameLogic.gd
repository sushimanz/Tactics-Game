class_name GameLogic
extends TileMapLayer

var units: Array = []
var tick: int = 0
@onready var tickTimer = $"../TickTimer"
@onready var readyInd = $"../UI/p1ReadyInd"
@onready var remoteReadyInd = $"../UI/p2ReadyInd"

#Multiplayer
var is_multiplayer: bool = false
var localReady: bool = false
var remoteReady: bool = false

#Troop Type Dropdown node access
@onready var troopTypeDropdown = $"../TroopTypeSelectDropdown"

func _ready() -> void:
<<<<<<< Updated upstream
	if is_multiplayer:
		print("GAME INITIALIZING / Waiting for other player")
	else:
		print("Initializing test / singleplayer game")
	#Uncommment the line below if you want to test the game without second player (some functions dont work with only one player)
	#Global.gameState = GAMESTATE.START
=======
	for x in range(map_bounds[0].x, map_bounds[1].x):
		for y in range(map_bounds[0].y, map_bounds[1].y):
			obstructed[Vector2i(x, y)] = false
	
	for troop in deployables:
		troop.deployTroop.connect(_try_to_deploy)

func deploy_unit(troop):
	var created_unit = hostUnit.instantiate()
	created_unit.global_position = map_to_local(deploy_location) #+ Vector2(125, 125)
	
	hosts.add_child(created_unit)
	created_unit.set_troop_values(troop)


func add_units():
	var created_unit
	for unit in hosts.get_children():
		created_unit = unit.instantiate()
		hosts.add_child(created_unit)
	
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
>>>>>>> Stashed changes

func _rand_deploy():
	for deployable_troop in deployables:
		if deployable_troop.deployable:
			print("Randomly deploy ", deployable_troop.name)

#func spawn_rand_troop(troopBox):
	##print(deployable_troop.name)
	#for x in randi_range(map_bounds[0].x, map_bounds[1].x):
		#for y in randi_range(map_bounds[0].y, map_bounds[1].y):
			#
			#
	#var is_valid_x = rand_loc.x >= map_bounds[0].x and rand_loc.x < map_bounds[1].x
	#var is_valid_y = rand_loc.y >= map_bounds[0].y and rand_loc.y < map_bounds[1].y
	#
	##Only do deploy at a valid location
	#if is_valid_x and is_valid_y:
		#can_deploy = true
		#deploy_location = rand_temp
		##print(deploy_location)
	#else:
		#can_deploy = false
	#
	#if can_deploy and (obstructed[deploy_location] == false):
		#print("Can Randomly Deploy ", troopBox.name," the ", troopBox.troop.troop_type, " at ", deploy_location)
		#obstructed[deploy_location] = true
		#deploy_unit(troopBox.troop)
		#troopBox._disable()
	#else:
		#print("Can't deploy troop here! Location is obstructed.")

func _rand_deploy():
	for deployable_troop in deployables:
		if deployable_troop.deployable:
			print("Randomly deploy ", deployable_troop.name)

#func spawn_rand_troop(troopBox):
	##print(deployable_troop.name)
	#for x in randi_range(map_bounds[0].x, map_bounds[1].x):
		#for y in randi_range(map_bounds[0].y, map_bounds[1].y):
			#
			#
	#var is_valid_x = rand_loc.x >= map_bounds[0].x and rand_loc.x < map_bounds[1].x
	#var is_valid_y = rand_loc.y >= map_bounds[0].y and rand_loc.y < map_bounds[1].y
	#
	##Only do deploy at a valid location
	#if is_valid_x and is_valid_y:
		#can_deploy = true
		#deploy_location = rand_temp
		##print(deploy_location)
	#else:
		#can_deploy = false
	#
	#if can_deploy and (obstructed[deploy_location] == false):
		#print("Can Randomly Deploy ", troopBox.name," the ", troopBox.troop.troop_type, " at ", deploy_location)
		#obstructed[deploy_location] = true
		#deploy_unit(troopBox.troop)
		#troopBox._disable()
	#else:
		#print("Can't deploy troop here! Location is obstructed.")

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
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	#remoteReadyCheck.rpc(localReady)



##Old dropdown system
#func _on_troop_dropdown_type_selected(index: int) -> void:
	#var selected_troopType = troopTypeDropdown.get_item_text(index)
	#var troopType = TroopMatcher.get_troop_type(selected_troopType)
	#
	##For now, sets all players as the same troop type. Need to get individual selection later, maybe by making a troop array for each player
	#units = get_children()
	#for unit in units:
		#unit.set_troop_values(troopType)
	#
	###Destroy dropdown and free the selector script when it works for multiple troops, since it should only occur at the game start
	##troopTypeDropdown.queue_free()
	##troopTypeSelector = null
=======
	#if Multiplayer.is_multi:
		#remoteReadyCheck.rpc(localReady)
>>>>>>> Stashed changes
=======
	#if Multiplayer.is_multi:
		#remoteReadyCheck.rpc(localReady)
>>>>>>> Stashed changes



##Old multiplayer stuff
#@rpc("any_peer","call_remote","reliable")
#func remoteReadyCheck(inReady) -> void:
	##print(multiplayer.get_unique_id())
	#remoteReady = inReady
	#if remoteReady:
		#remoteReadyInd.color = Color(0.0,1.0,0.0,1.0)
	#else:
		#remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
	#
<<<<<<< Updated upstream
<<<<<<< Updated upstream
	#if is_multiplayer:
		#if inReady and localReady:
			#print("Both players ready, Starting round")
			#startRound.rpc()
	#else:
		#startRound.rpc()
=======
=======
>>>>>>> Stashed changes
	#if Multiplayer.is_multi:
		#if inReady and localReady:
			#print("Both players ready, Starting round")
			##startRound.rpc()
	#else:
		#pass
		##startRound.rpc()
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
