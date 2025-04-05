extends Control

@onready var army = $Anchor/ArmySelect
@onready var squad = $Anchor/Squad
@onready var info_panel = $Anchor/TroopInfoPanel

@onready var timer = $SelectorTimer
@onready var p1ReadyRect = $Anchor/ReadyToStartButton/p1Ready
@onready var p2ReadyRect = $Anchor/ReadyToStartButton/p2Ready
@onready var timeLabel = $Anchor/ReadyToStartButton/TimeLabel
@onready var waitingLabel = $Anchor/waitingText
@onready var readyButton = $Anchor/ReadyToStartButton

signal selectionEnded

var localReady: bool = false
var remoteReady: bool = false

@export var wait_time: float = 10.0
@export var cur_time: int = 10
var prev_time: int = wait_time
#var readyToStart: bool = false
var startSelectorTimer: bool = false

var cur_troop: Troop
var armyTroops: Array
var squadTroops: Array

@rpc("any_peer","call_local","reliable")
func player2Join() -> void:
	readyButton.disabled = false
	waitingLabel.visible = false

func _ready() -> void:
	timer.wait_time = wait_time
	
	armyTroops = army.get_children()
	squadTroops = squad.get_children()
	
	for troop in armyTroops:
		troop.updateInfo.connect(_update_troop)
	for troop in squadTroops:
		troop.updateInfo.connect(_update_troop)

func _process(delta: float) -> void:
	if startSelectorTimer:
		var flt_time_left = timer.time_left
		cur_time = int(flt_time_left)
		#print(cur_time)
		
		if cur_time < prev_time:
			prev_time = cur_time
			timeLabel.text = str(cur_time+1)


func _update_troop(troop_str: String, troop: Troop) -> void:
	if troop != cur_troop:
		cur_troop = troop
		info_panel._update_info(troop_str, troop)

@rpc("any_peer","call_remote","reliable")
func readyCheck(inReady) -> void:
	remoteReady = inReady
	if remoteReady:
		p2ReadyRect.color = Color(0.0,1.0,0.0,1.0)
	else:
		p2ReadyRect.color = Color(1.0,0.0,0.0,1.0)
	timerUpdate.rpc(remoteReady and localReady)
	

@rpc("any_peer","call_local","reliable")
func timerUpdate(state: bool) -> void:
	if state:
		print("Both players ready, ending selection")
		timer.start()
		startSelectorTimer = true
	else:
		timer.stop()
		timeLabel.text = ""
		startSelectorTimer = false
		prev_time = wait_time


func _on_ready_to_start_button_pressed() -> void:
	if !localReady:
		localReady = true
		p1ReadyRect.color = Color(0.0,1.0,0.0,1.0)
	else:
		localReady = false
		p1ReadyRect.color = Color(1.0,0.0,0.0,1.0)
	
	readyCheck.rpc(localReady)



func _on_selector_timer_timeout() -> void:
		startSelectorTimer = false
		emit_signal("selectionEnded")
