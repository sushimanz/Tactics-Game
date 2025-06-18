class_name TroopData
extends Resource
##Troop data. Lists all stats and sprites for the given troop

enum NAME {UNKNOWN, ARCHER, BAITER, CANNON, CHRONOS, KNIGHT, LIGHTHOUSE, MERCENARY, SCRAPYARD, SNIPERBIRD, SNOWDROP, TVHEAD}
enum TYPE {TANK, SCOUT, SPECIALIST, DPS}
enum WEIGHT {HEAVY, MEDIUM, LIGHT}
enum STATE {IDLE, MOVE, ATTACK, HIT}
enum HEALTH_STATE {HIGH, MED, LOW, HIT}

##Troop name for descriptions/info
@export var troop_name_desc: String

static var troop_names: Array = NAME.keys()
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

##Might put damage and crit damage into something else, like the attack types thing, so that they can call the attack funciton
@export var dmg: int = 25
@export var crit_dmg: int = 0
#@export var max_troops_hit: int

@export var icon: CompressedTexture2D
@export var portrait: SpriteFrames
@export var sprite_sheet: SpriteFrames
##This is used in any case that a sprite has an alternative sprite sheet
@export var alternative_sprite_sheet: SpriteFrames
@export var extra_sprite_sheet: SpriteFrames

##Attack types and their relative damage (Need to add buff/debuff somehow...)
@export var attack_types: Dictionary[String, Array]
##Just special troop info basically
@export var extra_info: String = "None"

var current_health: float
var current_actions: int
var current_attacks: int
var current_moves: int
var current_reinforcements: int
var current_troops_hit: int = 0
