class_name Troop
extends Resource

var max_health: int
var max_moves: int
var max_attacks: int
var dmg: int
var atk_range: int
var max_troops_hit: int

var reinforcements: int
var reinforce_turns: int

var icon: CompressedTexture2D

var troop_type: String = "default"
var attack_types: String = "default"
var extra_info: String = "default"
