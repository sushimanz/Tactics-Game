extends TileMapLayer

var tokens: Array = []
var tick: int = 0
@onready var tTimer = $"../TickTimer"
@onready var readyInd = $"../UI/readyInd"


@export var pReady: bool = false
	#set(val):
		#P1Ready = val
		#readyCheck()
@export var P2Ready: bool = false
	#set(val):
		#P2Ready = val
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
	if remoteReady and pReady:
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
	
	##Destroy dropdown and free the selector script when it works for multiple troops
	#troopTypeDropdown.queue_free()
	#troopTypeSelector = null


func _on_button_pressed() -> void:
	pReady = true
	readyInd.visible = pReady
	readyCheck.rpc(ready)
