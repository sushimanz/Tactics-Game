extends Control

@onready var army = $Anchor/ArmySelect
@onready var squad = $Anchor/Squad
@onready var info_panel = $Anchor/TroopInfoPanel

var cur_troop: Troop
var armyTroops: Array
var squadTroops: Array

func _ready() -> void:
	armyTroops = army.get_children()
	squadTroops = squad.get_children()
	
	for troop in armyTroops:
		troop.updateInfo.connect(_update_troop)
	for troop in squadTroops:
		troop.updateInfo.connect(_update_troop)

func _update_troop(troop_str: String, troop: Troop) -> void:
	if troop != cur_troop:
		cur_troop = troop
		info_panel._update_info(troop_str, troop)
