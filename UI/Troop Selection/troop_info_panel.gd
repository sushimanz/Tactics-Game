extends Panel

#
var troop_type: String = "Archer"

#Stats
var health: String = "110"
var max_moves: String = "2"
var damage: String = "13"
var atk_range: String = "6"
var attack_types: String = "attack types here"
var extra_info: String = "info here"

@onready var title_label = $TitleBG/Label
@onready var info_label = $Panel/Label2

func _ready() -> void:
	if title_label.text != troop_type:
		title_label.text = troop_type
		
		info_label.text = "Health: " + health \
		+ "\nMoves: " + max_moves \
		+ "\nDamage: " + damage \
		+ "\nRange: " + atk_range \
		+ "\nAttack Types: \n" \
		+ attack_types \
		+ "\nExtra Info: \n" \
		+ extra_info

func _update_info(troop_str: String, troop: Troop) -> void:
	if troop is Troop:
		troop_type = troop_str
		health = str(troop.health)
		max_moves = str(troop.max_moves)
		damage = str(troop.dmg)
		atk_range = str(troop.atk_range)
		attack_types = troop.attack_types
		extra_info = troop.extra_info
		
		if title_label.text != troop_type:
			title_label.text = troop_type
			
			info_label.text = "Health: " + health \
			+ "\nMoves: " + max_moves \
			+ "\nDamage: " + damage \
			+ "\nRange: " + atk_range \
			+ "\nAttack Types: \n" \
			+ attack_types \
			+ "\nExtra Info: \n" \
			+ extra_info
