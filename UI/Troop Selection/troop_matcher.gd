class_name TroopMatcher
extends Node

static var troopTypes: Array = ["Archer", "Baiter", "Cannon Wheels", "Demoman", "Engineer", "Heavy", "Knight", "Medic", "Pyro", "Scout", "Sniper", "Soldier", "Spy", "TV Head", "Scrapyard Girl"]

#Get the troop type based on string input
static func get_troop_type(troop: String) -> Troop:
	#print("Troop Selected: ", troop)
	match troop:
		"Archer":
			return Archer.new()
		"Baiter":
			return Baiter.new()
		"Cannon Wheels":
			return CannonWheels.new()
		"Demoman":
			return Demoman.new()
		"Engineer":
			return Engineer.new()
		"Heavy":
			return Heavy.new()
		"Knight":
			return Knight.new()
		"Medic":
			return Medic.new()
		"Pyro":
			return Pyro.new()
		"Scout":
			return Scout.new()
		"Scrapyard Girl":
			return ScrapyardGirl.new()
		"Sniper":
			return Sniper.new()
		"Soldier":
			return Soldier.new()
		"Spy":
			return Spy.new()
		"TV Head":
			return TVHead.new()
		
		#Set default to null (test values) if no match found
		_:
			#print("No troop match found!")
			return null

static func random_troop() -> Troop:
	var rand_troop = troopTypes[randi_range(0, len(troopTypes)-1)]
	print("Random Troop is: ", rand_troop)
	return get_troop_type(rand_troop)
