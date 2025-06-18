class_name PortraitUI
extends UI
##Portrait user interface. This is just the UI where you can see all your friendly troops. 

@onready var portraits = $Portraits

##Troops that have already been used
var troops_set: Dictionary[int, String]
##Troops that have not yet been used
var troops_unset: Array[String]

func _ready() -> void:
	set_portraits()

##Sets the portraits to match friendly squad troops
func set_portraits():
	print("\n!!! Setting Portraits !!!\n")
	
	troops_unset.clear()
	for troop in TroopData.NAME:
		#print(troop)
		if troop != "UNKNOWN":
			troops_unset.append(troop)
	
	print("Initial Unset troops: ", troops_unset)
	
	for key in SquadData.friendly_troops:
		var val = SquadData.friendly_troops[key]
		if val != null:
			#print("Unset ", TroopData.troop_names[val.troop_name])
			troops_unset.erase(TroopData.troop_names[val.troop_name])
	
	print("Skimmed Unset troops: ", troops_unset)
	
	var i = 1
	for portrait in portraits.get_children():
		var friendly_troop: TroopData = SquadData.friendly_troops[i]
		if friendly_troop != null:
			portrait.set_portrait(friendly_troop.troop_name)
			troops_set[i] = TroopData.troop_names[friendly_troop.troop_name]
		else:
			var random_troop = randomize_troop()
			portrait.set_portrait(random_troop)
			troops_set[i] = TroopData.troop_names[random_troop]
		
		#print("Friendly troop set: ", TroopData.troop_names[friendly_troop.troop_name])
		troops_unset.erase(troops_set[i])
		i += 1
	
	print("Remaining Unset troops: ", troops_unset)
	print("Troops set: ", troops_set)
	
	print("\n!!! Portraits Set !!!\n")

func set_gamestate_text(in_text: String) -> void:
	%GamestateText.text = "Gamestate: " + in_text

func set_roundstate_text(in_text: String) -> void:
	%RoundstateText.text = "Roundstate: " + in_text

func set_time_left_text(in_text: String) -> void:
	%TimeLeftText.text = "Time Left: " + in_text

##Spits out a random and unique troop NAME
func randomize_troop() -> TroopData.NAME:
	var rand_troop_name: String = troops_unset[randi_range(0, (len(troops_unset)-1))]
	var rand_troop: TroopData.NAME = TroopData.NAME.get(rand_troop_name)
	return rand_troop
