extends TileMapLayer

var tokens: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"
@onready var readyInd = $"../UI/p1ReadyInd"
@onready var remoteReadyInd = $"../UI/p2ReadyInd"


var localReady: bool = false
var remoteReady: bool = false

#Troop Type Dropdown node access
@onready var troopTypeDropdown = $"../TroopTypeSelectDropdown"

func _ready() -> void:
	pass

@rpc("any_peer","call_local","reliable")
func start() -> void:
	tokens = get_children()

@rpc("any_peer","call_local", "reliable")
func roundTick() -> void:
	var check: bool
	for token in tokens:
		#Check next tick for updates to the unit
		token._check_for_next_tick()
		
		var test = token.tickUpdate(tick)
		if !check:
			check = test
	tick += 1
	
	## if all tokens dont have any moves left end the turn
	if !check:
		tTimer.stop()
		tick = 0
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
		readyInd.color = Color(1.0,0.0,0.0,1.0)
		localReady = false
		remoteReady = false
		print("round end")

@rpc("any_peer","call_remote","reliable")
func readyCheck(inReady) -> void:
	#print(multiplayer.get_unique_id())
	remoteReady = inReady
	tTimer.start()
	if remoteReady:
		remoteReadyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		remoteReadyInd.color = Color(1.0,0.0,0.0,1.0)
	
	if inReady and localReady:
		print("Both players ready, Starting round")
		tTimer.start()
		

func _process(delta: float) -> void:
	pass
	#if is_multiplayer_authority():
		#print(p1.readyState, p2.readyState)

func _on_tick_timer_timeout() -> void:
	roundTick.rpc()

func _on_troop_dropdown_type_selected(index: int) -> void:
	var selected_troopType = troopTypeDropdown.get_item_text(index)
	var troopType = TroopTypeSelector.get_troop_type(selected_troopType)
	
	#For now, sets all players as the same troop type. Need to get individual selection later, maybe by making a troop array for each player
	tokens = get_children()
	for token in tokens:
		token.set_troop_values(troopType)
	
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
