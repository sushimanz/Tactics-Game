class_name GameStateLogic
extends Node

enum GAMESTATE {INIT, DEPLOY, START, PLAN, ACTIVE, END}
var gameState: GAMESTATE

#Deploy Timer
var deployTimer: Timer
var deploy_end_time: int = 40

#Start Timer (If doing a pre-plan stage before player interaction)
var startTimer: Timer
var start_end_time: int = 3

#Plan Timer
var planTimer: Timer
var plan_end_time: int = 30

#Timers
var prev_time_left: int = 999

func updateTimer(timer: Timer) -> bool:
	var time_left = int(floor(timer.time_left))
	
	if prev_time_left > time_left:
		#print(timer.name, " Time Left: ", prev_time_left)
		prev_time_left = time_left
		#Updates for every second
	
	if timer.is_stopped() or time_left <= 0:
		return false
	else:
		return true

##NOTE INIT GAMESTATE
func _game_init():
	print("INITIALIZING ON GAMESTATE INIT ", gameState)
	
	deployTimer.wait_time = deploy_end_time
	startTimer.wait_time = start_end_time
	planTimer.wait_time = plan_end_time
	
	#Other things that need to happen transferring gamestates
	
	#Go to deploy after initializing game
	gameState = GAMESTATE.DEPLOY
	prev_time_left = float(deployTimer.wait_time)
	deployTimer.start()
	print("CHANGE GAMESTATE TO: DEPLOY ", gameState)


##NOTE DEPLOY GAMESTATE
func _deploy_phase() -> bool:
	var ongoing = updateTimer(deployTimer)
	if ongoing: #and !players_ready:
		return true
	else:
		##TODO player check (multiplayer)
		#if deployTimer ends OR both players ready
		return false

#Do when deployment is over
func _on_deploy_phase_end():
	gameState = GAMESTATE.START
	prev_time_left = startTimer.wait_time
	startTimer.start()
	print("CHANGE GAMESTATE TO: START ", gameState)


##NOTE START GAMESTATE
func _round_start() -> bool:
	var ongoing = updateTimer(startTimer)
	if ongoing:
		return true
	else:
		#if startTimer ends
		gameState = GAMESTATE.PLAN
		prev_time_left = planTimer.wait_time
		planTimer.start()
		return false
	


##NOTE PLAN GAMESTATE
#Where planning phase occurs and pathing is created
func _planning_phase() -> bool:
	##TODO player check (multiplayer)
	#if planTimer ends OR both players ready
	if updateTimer(planTimer): #or players_ready:
		return true
	else:
		return false
	
	#TODO make sure the starting position of the troop stays the same
	#So that the player can't abuse dragging off the window

#Do when planning is over
func _on_planning_phase_end():
	gameState = GAMESTATE.ACTIVE
	print("CHANGE GAMESTATE TO: ACTIVE ", gameState)


##NOTE ACTIVE GAMESTATE
#Do when troops should do moves and attacks
func _active_phase() -> bool:
	
	##TODO 
	#if active phase ends 
	#(tick timer stops running fully for each troop, maybe make a bool for each troop to check if they are done doing stuff)
	return false

#Do when active phase has ended
func _on_active_phase_end():
	gameState = GAMESTATE.END
	print("CHANGE GAMESTATE TO: END ", gameState)


##NOTE END GAMESTATE
#Do when a turn just started, mostly just to update troop starting location
func _round_end():
	gameState = GAMESTATE.START
	prev_time_left = startTimer.wait_time
	startTimer.start()
	print("CHANGE GAMESTATE TO: START ", gameState)
	
	#TODO get the starting position of the troop (would be current location)


##NOTE call to update the GAMESTATE
func updateGameState() -> void:
	match gameState:
		#Do ONLY at the start of the game (Not sure if necessary)
		GAMESTATE.INIT:
			_game_init()
		
		#Do ONLY at the start of the game, after intializing
		GAMESTATE.DEPLOY:
			if !_deploy_phase():
				_on_deploy_phase_end()
		
		#Do when a turn just started, mostly just to update troop starting location
		GAMESTATE.START:
			_round_start()
		
		#Do during the planning phase, there is player troop interaction here
		GAMESTATE.PLAN:
			if !_planning_phase():
				_on_planning_phase_end()
		
		#Do when a turn is in progress, there is NO playert troop interaction here
		GAMESTATE.ACTIVE:
			if !_active_phase():
				_on_active_phase_end()
		
		GAMESTATE.END:
			_round_end()
		
		_:
			print("No Gamestate, there is an issue here!")
			gameState = GAMESTATE.INIT
			print("RE-INITIALIZE GAMESTATE")
