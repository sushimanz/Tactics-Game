class_name Squad
extends Control

func _ready() -> void:
	SquadData._reset()

func _on_troop_card_squad_troop_set(troop: TroopData) -> void:
	set_squad_data(1, troop)

func _on_troop_card_2_squad_troop_set(troop: TroopData) -> void:
	set_squad_data(2, troop)

func _on_troop_card_3_squad_troop_set(troop: TroopData) -> void:
	set_squad_data(3, troop)

func _on_troop_card_4_squad_troop_set(troop: TroopData) -> void:
	set_squad_data(4, troop)

func _on_troop_card_5_squad_troop_set(troop: TroopData) -> void:
	set_squad_data(5, troop)

func set_squad_data(i: int, troop: TroopData) -> void:
	SquadData.friendly_troops[i] = troop
