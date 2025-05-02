extends Menu

func _on_back_button_pressed() -> void:
	menuManager._go_back()

func _on_next_button_pressed() -> void:
	main.update_mainstate(Main.MAINSTATE.START_GAME)
