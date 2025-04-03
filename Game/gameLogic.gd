extends TileMapLayer

var units: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"
@onready var readyInd = $"../UI/p1ReadyInd"
@onready var remoteReadyInd = $"../UI/p2ReadyInd"

#Start timer (If doing a pre-plan stage before player interaction)
@onready var startTimer: Timer = $"../StartTimer"
@export var start_end_time: int = 3
var start_time_left: float = start_end_time
var prev_start_time_left: int

#Plan Timer
@onready var planTimer: Timer = $"../PlanningTimer"
@export var plan_end_time: int = 30		#Time in seconds
var plan_time_left: float = plan_end_time
var prev_plan_time_left: int

enum GAMESTATE {INIT, START, PLAN, ACTIVE, END}

var localReady: bool = false
var remoteReady: bool = false

#Troop Type Dropdown node access
@onready var troopTypeDropdown = $"../TroopTypeSelectDropdown"

func _ready() -> void:
	print("GAME INITIALIZING / Waiting for other player")
	#Uncommment the line below if you want to test the game without second player (some functions dont work with only one player)
	#Global.gameState = GAMESTATE.START

@rpc("any_peer","call_local","reliable")
func initialize() -> void:
	#Timer variables for easier debugging and printing
	startTimer.wait_time = start_end_time
	planTimer.wait_time = plan_end_time
	prev_start_time_left = start_end_time
	prev_plan_time_left = plan_end_time
	
	units = get_children()
	print("Second player joined, Starting game")
	Global.gameState = GAMESTATE.START
	startTimer.start()

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
		tTimer.stop()
		tick = 0
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
		readyInd.color = Color(1.0,0.0,0.0,1.0)
		localReady = false
		remoteReady = false
		Global.gameState = GAMESTATE.END
		print("round end")

@rpc("any_peer","call_remote","reliable")
func readyCheck(inReady) -> void:
	#print(multiplayer.get_unique_id())
	remoteReady = inReady
	if remoteReady:
		remoteReadyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
	
	if inReady and localReady:
		print("Both players ready, Starting round")
		startRound.rpc()

@rpc("any_peer","call_local","reliable")
func startRound()-> void:
	Global.gameState = GAMESTATE.ACTIVE
	planTimer.stop()


func _pre_planning_phase():
	start_time_left = int(floor(startTimer.time_left))
	if prev_start_time_left > start_time_left:
		print("Pre-Planning Time Left: ", prev_start_time_left)
		prev_start_time_left = start_time_left
		#Updates for every second

#Where planning5 phase occurs and pathing is created
func _planning_phase():
	plan_time_left = int(floor(planTimer.time_left))
	if prev_plan_time_left > plan_time_left:
		print("Planning Time Left: ", prev_plan_time_left)
		prev_plan_time_left = plan_time_left
		#Updates for every second
	
	#if turnPreviousCoord != turnStartCoord:
		#turnPreviousCoord = turnStartCoord

#Do when a turn just started, mostly just to update troop starting location
func _on_turn_started():
	for unit in units:
		unit.reset()


#Not sure if this is really needed but good to keep in the loop for visual
func _on_turn_ended():
	for unit in units:
		unit.on_end()
	#print("Troop End Coordinate: ", turnEndCoord)

func forceStart() -> void:
	localReady = true
	remoteReady = true
	remoteReadyInd.color = Color(0.0,1.0,0.0,1.0)
	readyInd.color = Color(0.0,1.0,0.0,1.0)
	Global.gameState = GAMESTATE.ACTIVE

func _process(delta: float) -> void:
	if tTimer.is_stopped():
		updateGameState()

func updateGameState() -> void:
	match Global.gameState:
		#Do ONLY at the start of the game, mostly for the troop selector and deployment at the start
		GAMESTATE.INIT:
			pass
		
		#Do when a turn just started, mostly just to update troop starting location
		GAMESTATE.START:
			_pre_planning_phase()
		
		#Do during the planning phase, there is player troop interaction here
		GAMESTATE.PLAN:
			_planning_phase()
		
		#Do when a turn is in progress, there is NO playert troop interaction here
		GAMESTATE.ACTIVE:
			tTimer.start()
		
		GAMESTATE.END:
			_on_turn_ended()
			
			Global.gameState = GAMESTATE.START
			print("CHANGE GAMESTATE TO START")
			startTimer.start()
			#reset debug vars for time
			prev_start_time_left = start_end_time
			prev_plan_time_left = plan_end_time
		
		_:
			print("No Gamestate, there is an issue here!")
			Global.gameState = GAMESTATE.INIT
			print("INITIALIZE GAMESTATE")

func _on_tick_timer_timeout() -> void:
	roundTick()

func _on_troop_dropdown_type_selected(index: int) -> void:
	var selected_troopType = troopTypeDropdown.get_item_text(index)
	var troopType = TroopMatcher.get_troop_type(selected_troopType)
	
	#For now, sets all players as the same troop type. Need to get individual selection later, maybe by making a troop array for each player
	units = get_children()
	for unit in units:
		unit.set_troop_values(troopType)
	
	##Destroy dropdown and free the selector script when it works for multiple troops, since it should only occur at the game start
	#troopTypeDropdown.queue_free()
	#troopTypeSelector = null


func _on_button_pressed() -> void:
	if !localReady:
		localReady = true
		readyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		localReady = false
		readyInd.color = Color(1.0,0.0,0.0,1.0)
	
	readyCheck.rpc(localReady)


func _on_planning_timer_timeout() -> void:
	Global.gameState = GAMESTATE.ACTIVE
	print("CHANGE GAMESTATE TO ACTIVE")
	for unit in units:
		unit.on_start()


func _on_start_timer_timeout() -> void:
	_on_turn_started()
	Global.gameState = GAMESTATE.PLAN
	print("CHANGE GAMESTATE TO PLAN")
	planTimer.start()
