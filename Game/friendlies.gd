extends Control

signal _unit_selected(unit_id: Unit)

var selected_unit: Unit

func _on_child_entered_tree(node: Node) -> void:
	if node is Unit:
		selected_unit = node
		selected_unit._unit_selected.connect(unit_selected)

func unit_selected(unit_id: Unit = null) -> void:
	_unit_selected.emit(unit_id)
