class_name TroopTypeSelector
extends Node

#Get the troop type based on string input
func get_troop_type(troop: String) -> Troop:
	print("Troop Selected: ", troop)
	match troop:
		"Archer":
			return load("res://Troops/archer.gd").new()
		"Baiter":
			return load("res://Troops/baiter.gd").new()
		"Cannon Wheels":
			return load("res://Troops/cannon_wheels.gd").new()
		"Demoman":
			return load("res://Troops/demoman.gd").new()
		"Engineer":
			return load("res://Troops/engineer.gd").new()
		"Heavy":
			return load("res://Troops/heavy.gd").new()
		"Knight":
			return load("res://Troops/knight.gd").new()
		"Medic":
			return load("res://Troops/medic.gd").new()
		"Pyro":
			return load("res://Troops/pyro.gd").new()
		"Scout":
			return load("res://Troops/scout.gd").new()
		"Sniper":
			return load("res://Troops/sniper.gd").new()
		"Soldier":
			return load("res://Troops/soldier.gd").new()
		"Spy":
			return load("res://Troops/spy.gd").new()
		"TV Head":
			return load("res://Troops/tv_head.gd").new()
		
		#Set default to null (test values) if no match found
		_:
			print("No troop match found!")
			return null
