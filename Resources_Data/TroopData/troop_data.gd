##Extends out to all troops, listing their max and current stats
class_name TroopData
extends Resource

enum NAME {UNKNOWN, KNIGHT, BAITER, ARCHER, TVHEAD, SNOWDROP, MERCENARY, SNIPERBIRD, CANNON, CHRONOS}
enum TYPE {TANK, SCOUT, SPECIALIST, DPS}
enum WEIGHT {HEAVY, MEDIUM, LIGHT}
enum STATE {IDLE, MOVE, ATTACK, HIT}
enum HEALTH_STATE {HIGH, MED, LOW, HIT}

@export var troop_name: NAME
@export var troop_type: TYPE
@export var troop_weight: WEIGHT

#Max actions are the same for ALL troops, so change in this script directly
var max_actions: int = 5

@export var max_health: float = 100.0
@export var max_attacks: int = 2
@export var max_moves: int = 3

##move_speed = max tiles moved per move
@export var move_speed: int = 2

@export var reinforce_rounds: int = 1
@export var max_reinforcements: int = 5

##atk_range = 1 means all adjacent tiles
@export var atk_range: int = 1
@export var dmg: int = 25
@export var crit_dmg: int = 0
#@export var max_troops_hit: int

#The dictionaries may need to be updated so that they can be changed more easily, or maybe it's fine, idk.
#Will change to Unknown Troop sprites by default when that is available as an option
@export var sprite_sheet: Dictionary[STATE, CompressedTexture2D] = {
	STATE.IDLE : preload("res://Assets/Troops/Knight/Knight2DBlue-Sheet.png"),
	STATE.MOVE : preload("res://Assets/Troops/Knight/Knight2DBlue-Sheet.png"),
	STATE.ATTACK : preload("res://Assets/Troops/Knight/Knight2DBlue-Sheet.png"),
	STATE.HIT : preload("res://Assets/Troops/Knight/Knight2DBlue-Sheet.png")
}
@export var portrait: Dictionary[HEALTH_STATE, CompressedTexture2D] = {
	HEALTH_STATE.HIGH : preload("res://Assets/Troops/Knight/KnightShadeBlueIdle.png"),
	HEALTH_STATE.MED : preload("res://Assets/Troops/Knight/KnightShadeBlueIdle.png"),
	HEALTH_STATE.LOW : preload("res://Assets/Troops/Knight/KnightShadeBlueWeak.png"),
	HEALTH_STATE.HIT : preload("res://Assets/Troops/Knight/KnightShadeBlueHurt.png")
}

##v Not sure if any of this will be used, might end up in unitData or something v
@export var attack_types: Dictionary[String, String]
@export var extra_info: String = "None"

var current_health: float
var current_actions: int
var current_attacks: int
var current_moves: int
var current_reinforcements: int
var current_troops_hit: int = 0
