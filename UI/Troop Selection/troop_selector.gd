extends Control

@onready var army = $Anchor/ArmySelect
@onready var squad = $Anchor/Squad
@onready var info_panel = $Anchor/TroopInfoPanel

@onready var timer = $SelectorTimer
@onready var p1ReadyRect = $Anchor/ReadyToStartButton/p1Ready
@onready var p2ReadyRect = $Anchor/ReadyToStartButton/p2Ready
@onready var timeLabel = $Anchor/ReadyToStartButton/TimeLabel



@export var wait_time: float = 10.0
@export var cur_time: int = 10
var prev_time: int = wait_time
#var readyToStart: bool = false
var startSelectorTimer: bool = false

var cur_troop: Troop
var armyTroops: Array
var squadTroops: Array


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
	
	if cur_time <= 0:
		#readyToStart = true
		visible = false

func _update_troop(troop_str: String, troop: Troop) -> void:
	if troop != cur_troop:
		cur_troop = troop
		info_panel._update_info(troop_str, troop)


func _on_ready_to_start_button_pressed() -> void:
	if !startSelectorTimer:
		startSelectorTimer = true
		
		if true:
			p1ReadyRect.color = Color(0.0, 1.0, 0.0, 1.0)
			p2ReadyRect.color = Color(0.0, 1.0, 0.0, 1.0)
		
		timer.start()
	else:
		startSelectorTimer = false
		
		#ONLY set prev_time to wait_time IF both players unready. Or just one, either way
		if true:
			prev_time = wait_time
			p1ReadyRect.color = Color(1.0, 0.0, 0.0, 1.0)
			p2ReadyRect.color = Color(1.0, 0.0, 0.0, 1.0)
		
		timer.stop()
		timeLabel.text = ""
