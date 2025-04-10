class_name Troop
extends Resource

var health: int
var max_moves: int
var dmg: int
var atk_range: int
var max_troops_hit: int

var lives: int
var respawn_turns: int

var icon: CompressedTexture2D

var troop_type: String = "default"
var attack_types: String = "default"
var extra_info: String = "default"
