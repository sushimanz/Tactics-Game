class_name TroopData
extends Resource

#NOTE: TroopData Class extends out to all troops, listing their max and current stats

@export var max_health: int = 100
var current_health = max_health
@export var max_actions: int = 5
var current_actions = max_actions
@export var max_attacks: int = 2
var current_attacks = max_attacks
@export var max_moves: int = 3
var current_moves = max_moves

#NOTE: move_speed = max tiles moved per move
@export var move_speed: int = 2

@export var reinforce_turns: int
@export var max_reinforcements: int = 5
var current_reinforcements = max_reinforcements

@export var dmg: int = 25
@export var atk_range: int = 0
@export var max_troops_hit: int
var current_troops_hit: int = 0

@export var icon: CompressedTexture2D

##v Not sure if any of this will be used, might end up in unitData or something v
@export var troop_type: String = "default"
@export var attack_types: String = "default"
@export var extra_info: String = "default"
