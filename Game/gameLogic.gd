extends TileMapLayer

var tokens: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"
@onready var readyInd = $"../UI/p1ReadyInd"
@onready var remoteReadyInd = $"../UI/p2ReadyInd"


var localReady: bool = false
var remoteReady: bool = false

#Troop Type Dropdown and Selector Logic
@onready var troopTypeDropdown = $"../TroopTypeSelectDropdown"
@onready var troopTypeSelector = load("res://Game/troopTypeSelector.gd").new()

func _ready() -> void:
	pass

@rpc("any_peer","call_local","reliable")
func start() -> void:
	tokens = get_children()

@rpc("any_peer","call_local", "reliable")
func roundTick() -> void:
	var check: bool
	for token in tokens:
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
	var troopType = troopTypeSelector.get_troop_type(selected_troopType)
	
	#For now, sets all players as the same troop type. Need to get individual selection later
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
