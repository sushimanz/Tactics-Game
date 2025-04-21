class_name AttackAction extends UnitPlanning

@onready var unit: UnitPlanning = $"."
# @onready var animationPlayer: animationPlayer2D     For animating attacks once we have them

@export var selectedTroop: Troop

# var gridMap = unit.tileMap
# var targetTile: Tile[0]        Need to make Tile object so location can be grabbed
# var troopPos = unit.turnCurrentPostion
var targetPos: Array[Tile] = []
# Still need to find better way of accessing selected troop and their stats
# var troopRange: int = selectedTroop.atk_range
# var troopDmg: int = selectedTroop.dmg

# Need to assign attack types and their match cases to units
enum AttackType {
	MELEE,
	RANGED,
	AoE
}
# var mouseHoveringTile: bool = false       A bool or signal that knows which tile is being hovered
var mousePos: Vector2i
var targetInRange: bool = false
var mouseSelected: bool = false
var selectedTile: Tile



func _physics_process(delta: float) -> void:
	mousePos = get_viewport().get_mouse_position()
	# Print statement for testing
	# print("Mouse X= " + mousePos.x + "\n" + "Mouse Y= " + mousePos.Y)
	
	# Find out if 
	if Input.is_action_just_pressed("LClick"):
		mouseSelected = true



func attack_target(_tileMap, troopPos, troopRange) -> Array[Tile]:
	# Using distance formula to find path from troop to mouse
	var rangeDistance = sqrt(((mousePos.x - troopPos.x)^2) + ((mousePos.y - troopPos.y))^2)
	# Comparing rangeDistance to make sure its in the bounds of troop range
	if rangeDistance <= troopRange:
		targetInRange = true
	
	if mouseSelected && targetInRange:
		# Highlight tile using gamma once Tile object is made
		# var selectedTile: Tile = 
		targetPos.append(selectedTile)
	return targetPos
