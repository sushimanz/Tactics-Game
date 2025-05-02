extends BoxContainer

@onready var buttons: Array[Node] = get_children()

func _ready() -> void:
	_selected(buttons[0])

func _on_dm_button_pressed() -> void:
	_selected(buttons[0])

func _on_koth_button_pressed() -> void:
	_selected(buttons[1])

func _on_nexus_button_pressed() -> void:
	_selected(buttons[2])

func _selected(button: Node) -> void:
	button.is_selected = true
	button.set_brightness_percent_to(button.selected_brightness)
	print(button.text, " is selected")
	
	for btn in buttons:
		if btn.name != button.name:
			btn.is_selected = false
			btn.set_brightness_percent_to(button.normal_brightness)
	
