extends TileMapLayer

var tokens: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"
@onready var p1ReadyInd = $"../UI/p1ReadyInd"


@export var p1Ready: bool = false
	#set(val):
		#p1Ready = val
		#readyCheck()
@export var p2Ready: bool = false
	#set(val):
		#p2Ready = val
		#readyCheck()

#Troop Type Dropdown and Selector Logic
@onready var troopTypeDropdown = $"../TroopTypeSelectDropdown"
@onready var troopTypeSelector = load("res://Game/troopTypeSelector.gd").new()

func _ready() -> void:
	pass

func start() -> void:
	tokens = get_children()

@rpc("any_peer","call_local", "reliable")
func startRound() -> void:
	var check: bool
	for token in tokens:
		var test = token.tickUpdate(tick)
		if !test:
			if !check:
				check = test
	tick += 1

@rpc("any_peer","call_remote","reliable")
func readyCheck(remoteReady) -> void:
	#print(multiplayer.get_unique_id())
	if remoteReady and p1Ready:
		print("Both players ready, Starting round")
		startRound.rpc()
		

func _process(delta: float) -> void:
	pass
	#if is_multiplayer_authority():
		#print(p1.readyState, p2.readyState)

func _on_tick_timer_timeout() -> void:
	startRound()

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
	if !p1Ready:
		p1Ready = true
		p1ReadyInd.color = Color(0.0,1.0,0.0,1.0)
	else:
		p1Ready = false
		p1ReadyInd.color = Color(1.0,0.0,0.0,1.0)
	
	readyCheck.rpc(ready)
