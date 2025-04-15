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

func _ready() -> void:
	if is_multiplayer:
		print("GAME INITIALIZING / Waiting for other player")
	else:
		print("Initializing test / singleplayer game")


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
	#if is_multiplayer:
		#if inReady and localReady:
			#print("Both players ready, Starting round")
			#startRound.rpc()
	#else:
		#startRound.rpc()
