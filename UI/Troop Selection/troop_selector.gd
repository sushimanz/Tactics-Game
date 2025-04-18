extends Control

@onready var army = $Anchor/ArmySelect
@onready var squad = $Anchor/Squad
@onready var info_panel = $Anchor/TroopInfoPanel

@onready var rootNode = $"."
@onready var timer = $SelectorTimer
@onready var p1ReadyRect = $Anchor/ReadyToStartButton/p1Ready
@onready var p2ReadyRect = $Anchor/ReadyToStartButton/p2Ready
@onready var timeLabel = $Anchor/ReadyToStartButton/TimeLabel
@onready var waitingLabel = $Anchor/waitingText
@onready var readyButton = $Anchor/ReadyToStartButton

signal selectionEnded(troops)

var localReady: bool = false
var remoteReady: bool = false

@export var wait_time: float = 1.0
var cur_time: int = wait_time
var prev_time: int = wait_time + 1
var startSelectorTimer: bool = false

var troopMatcher := TroopMatcher.new()
var valid_troops = troopMatcher.troopTypes

var cur_troop: Troop
var armyTroops: Array = []
var squadTroops: Array = []
var troops = {}

#Multiplayer
var readyToStart: bool = false

func _ready() -> void:
	timer.wait_time = wait_time
	
	armyTroops = army.get_children()
	squadTroops = squad.get_children()
	
	for troop in armyTroops:
		troop.updateInfo.connect(_update_troop)
	for troop in squadTroops:
		troop.updateInfo.connect(_update_troop)

func _process(_delta: float) -> void:
	if startSelectorTimer:
		var flt_time_left = timer.time_left
		cur_time = int(flt_time_left)
		#print(cur_time)
		
		if cur_time < prev_time:
			prev_time = cur_time
			timeLabel.text = str(cur_time+1)
			#Update for every second

@rpc("any_peer","call_local","reliable")
func timer_reset(inReady) -> void:
	if timer.is_stopped() and inReady:
		print("Ready Timer Started")
		timer.start()
		startSelectorTimer = true
	else:
		print("Ready Timer Stopped")
		timer.stop()
		timeLabel.text = ""
		startSelectorTimer = false
		prev_time = wait_time

func _update_troop(troop: Troop) -> void:
	if troop != cur_troop:
		cur_troop = troop
		info_panel._update_info(troop)

func _on_ready_to_start_button_pressed() -> void:
	if !localReady:
		localReady = true
		p1ReadyRect.color = Color(0.0,1.0,0.0,1.0)
		#p2ReadyRect.color = Color(0.0,1.0,0.0,1.0)
	else:
		localReady = false
		p1ReadyRect.color = Color(1.0,0.0,0.0,1.0)
		#p2ReadyRect.color = Color(1.0,0.0,0.0,1.0)
	
	if Multiplayer.is_multi:
		remoteReadyCheck.rpc(localReady)
	else:
		timer_reset(localReady)

func _on_selector_timer_timeout() -> void:
	startSelectorTimer = false
	for troop in squadTroops:
		if troop.troop_type not in valid_troops:
			troops[troop.name] = troopMatcher.random_troop()
			#print(troop.troop_type, " is an invalid troop. Randomizing to ", troops[troop.name].troop_type)
		else:
			troops[troop.name] = (troopMatcher.get_troop_type(troop.troop_type))
	
	transmit_info()
	self.queue_free()

func transmit_info() -> void:
	emit_signal("selectionEnded", troops)



##OLD MULTIPLAYER STUFF
@rpc("any_peer","call_remote","reliable")
func remoteReadyCheck(inReady) -> void:
	remoteReady = inReady
	if remoteReady:
		p2ReadyRect.color = Color(0.0,1.0,0.0,1.0)
	else:
		p2ReadyRect.color = Color(1.0,0.0,0.0,1.0)
	timer_reset.rpc(remoteReady and localReady)
