class_name PortraitUI
extends UI

@onready var portraits = $Portraits

var troops_set: Dictionary[int, String]
var troops_unset: Array[String]

func _ready() -> void:
	set_portraits()

func set_portraits():
	print("\n!!! Setting Portraits !!!\n")
	
	troops_unset.clear()
	for troop in TroopData.NAME:
		#print(troop)
		if troop != "UNKNOWN":
			troops_unset.append(troop)
	
	print("Initial Unset troops: ", troops_unset)
	
	var i = 1
	for portrait in portraits.get_children():
		var friendly_troop: TroopData = SquadData.friendly_troops[i]
		if friendly_troop != null:
			portrait.set_portrait(friendly_troop.troop_name)
			troops_set[i] = TroopData.troop_names[friendly_troop.troop_name]
			print("Friendly troop set: ", friendly_troop.troop_name)
		else:
			var random_troop = randomize_troop()
			portrait.set_portrait(random_troop)
			troops_set[i] = TroopData.troop_names[random_troop]
		
		troops_unset.erase(troops_set[i])
		i += 1
	
	print("Troops set: ", troops_set)
	print("Remaining Unset troops: ", troops_unset)

func randomize_troop() -> TroopData.NAME:
	var rand_troop_name: String = troops_unset[randi_range(0, (len(troops_unset)-1))]
	var rand_troop: TroopData.NAME = TroopData.NAME.get(rand_troop_name)
	return rand_troop
