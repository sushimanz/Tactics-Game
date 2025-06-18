class_name SquadData
extends Resource
##Squad data. Holds information for squads of troops

##Order for friendly troops in their designated squad
static var friendly_troops: Dictionary[int, TroopData] = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
	5 : null
}

##Order for enemy troops in their designated squad
static var enemy_troops: Dictionary[int, TroopData] = {
	1 : null,
	2 : null,
	3 : null,
	4 : null,
	5 : null
}

##Resets the friendly and enemy troop dictionaries to original null values
static func _reset():
	for troop in friendly_troops:
		friendly_troops[troop] = null
	for troop in enemy_troops:
		enemy_troops[troop] = null
