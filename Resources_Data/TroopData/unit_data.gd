class_name UnitData
extends Resource

static var unit: PackedScene = preload("res://Game/Unit/Unit.tscn")

#Just in case there are name changes, this way I don't gotta redo all them lines in the match statements
static var troop_data = TroopData
static var path_data = TroopPathData

static func get_troop(troop_name = troop_data.NAME) -> Resource:
	match troop_name:
		troop_data.NAME.UNKNOWN:
			return path_data.unknown
		troop_data.NAME.KNIGHT:
			return path_data.knight
		troop_data.NAME.BAITER:
			return path_data.baiter
		troop_data.NAME.ARCHER:
			return path_data.archer
		troop_data.NAME.TVHEAD:
			return path_data.tvhead
		troop_data.NAME.SNOWDROP:
			return path_data.snowdrop
		troop_data.NAME.MERCENARY:
			return path_data.mercenary
		troop_data.NAME.SNIPERBIRD:
			return path_data.sniperbird
		troop_data.NAME.SNIPERBIRD:
			return path_data.sniperbird
		troop_data.NAME.CANNON:
			return path_data.cannon
		troop_data.NAME.CHRONOS:
			return path_data.chronos
		#troop_data.NAME.SCRAPYARD_GIRL:
			#return path_data.scrapyard_girl
		#troop_data.NAME.LIGHTHOUSE_GUARDIAN:
			#return path_data.lighthouse_guardian
		_:
			print("There was an invalid troop name entered")
	
	return path_data.unknown
