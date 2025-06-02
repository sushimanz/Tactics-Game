class_name SquadData
extends Resource

static var friendly_troops: Dictionary[int, TroopData] = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
	5 : null
}

static var enemy_troops: Dictionary[int, TroopData] = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
	5 : null
}

static func _reset():
	for troop in friendly_troops:
		friendly_troops[troop] = null
	for troop in enemy_troops:
		enemy_troops[troop] = null
