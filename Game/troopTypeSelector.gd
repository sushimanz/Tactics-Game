class_name TroopTypeSelector
extends Node

static var troopTypes: Array = ["Archer", "Batier", "Cannon Wheels", "Demoman", "Engineer", "Heavy", "Knight", "Medic", "Pyro", "Scout", "Sniper", "Soldier", "Spy", "TV Head", "Scrapyard Girl"]

#Get the troop type based on string input
static func get_troop_type(troop: String) -> Troop:
	#print("Troop Selected: ", troop)
	match troop:
		"Archer":
			return preload("res://Troops/archer.gd").new()
		"Baiter":
			return preload("res://Troops/baiter.gd").new()
		"Cannon Wheels":
			return preload("res://Troops/cannon_wheels.gd").new()
		"Demoman":
			return preload("res://Troops/demoman.gd").new()
		"Engineer":
			return preload("res://Troops/engineer.gd").new()
		"Heavy":
			return preload("res://Troops/heavy.gd").new()
		"Knight":
			return preload("res://Troops/knight.gd").new()
		"Medic":
			return preload("res://Troops/medic.gd").new()
		"Pyro":
			return preload("res://Troops/pyro.gd").new()
		"Scout":
			return preload("res://Troops/scout.gd").new()
		"Sniper":
			return preload("res://Troops/sniper.gd").new()
		"Soldier":
			return preload("res://Troops/soldier.gd").new()
		"Spy":
			return preload("res://Troops/spy.gd").new()
		"TV Head":
			return preload("res://Troops/tv_head.gd").new()
		"Scrapyard Girl":
			return preload("res://Troops/scrapyard_girl.gd").new()
		
		#Set default to null (test values) if no match found
		_:
			print("No troop match found!")
			return null

static func random_troop() -> Troop:
	var rand_troop = troopTypes[randi_range(0, len(troopTypes)-1)]
	print("Random Troop is: ", rand_troop)
	return get_troop_type(rand_troop)
